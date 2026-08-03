/*
 * SPDX-FileCopyrightText: 2019-2022 SiFli Technologies(Nanjing) Co., Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtconfig.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "string.h"
#include "rtthread.h"
#include "adc.h"

#define ADC_DEV_CHANNEL             7
#define ADC_SW_AVRA_CNT            (22)
#define ADC_RATIO_ACCURATE         (1000)
#define ADC_MAX_VOLTAGE_MV_3300    (3300)

/* The 52X VBAT input is divided by two before reaching the ADC. */
static float adc_vbat_factor = 2.01f;

/* Calibration values are replaced by factory data when available. */
static float adc_vol_offset = 822.0f;
static float adc_vol_ratio = 1068.0f;
static int adc_range = 1;
static uint32_t adc_max_vol_mv = ADC_MAX_VOLTAGE_MV_3300;

static ADC_HandleTypeDef hadc;
static uint32_t adc_thd_reg;
static uint32_t g_adc_slot;

static void example_adc_vbat_fact_calib(uint32_t voltage, uint32_t reg)
{
    float vol_from_reg;

    vol_from_reg = (reg - adc_vol_offset) * adc_vol_ratio / ADC_RATIO_ACCURATE;
    adc_vbat_factor = (float)voltage / vol_from_reg;
}

static int example_adc_calibration(uint32_t value1, uint32_t value2,
                                   uint32_t vol1, uint32_t vol2,
                                   float *offset, float *ratio)
{
    float gap1, gap2;
    uint32_t reg_max;

    if (offset == NULL || ratio == NULL)
        return 0;

    if (value1 == 0 || value2 == 0)
        return 0;

    gap1 = value1 > value2 ? value1 - value2 : value2 - value1;
    gap2 = vol1 > vol2 ? vol1 - vol2 : vol2 - vol1;

    if (gap1 == 0)
        return 0;

    *ratio = gap2 * ADC_RATIO_ACCURATE / gap1;
    adc_vol_ratio = *ratio;

    *offset = value1 - vol1 * ADC_RATIO_ACCURATE / adc_vol_ratio;
    adc_vol_offset = *offset;

    adc_thd_reg = adc_max_vol_mv * ADC_RATIO_ACCURATE / adc_vol_ratio + adc_vol_offset;
    reg_max = GPADC_ADC_RDATA0_SLOT0_RDATA >> GPADC_ADC_RDATA0_SLOT0_RDATA_Pos;
    if (adc_thd_reg >= (reg_max - 3))
        adc_thd_reg = reg_max - 3;

    return 1;
}

static HAL_StatusTypeDef utest_adc_calib(void)
{
    FACTORY_CFG_ADC_T cfg;
    int len = sizeof(FACTORY_CFG_ADC_T);

    adc_thd_reg = GPADC_ADC_RDATA0_SLOT0_RDATA >> GPADC_ADC_RDATA0_SLOT0_RDATA_Pos;
    rt_memset((uint8_t *)&cfg, 0, len);

    if (!BSP_CONFIG_get(FACTORY_CFG_ID_ADC, (uint8_t *)&cfg, len))
    {
        return HAL_ERROR;
    }

    if (cfg.vol10 == 0 || cfg.vol25 == 0)
        return HAL_ERROR;

    cfg.vol10 &= 0x7fff;
    cfg.vol25 &= 0x7fff;
    adc_range = 1;
    adc_max_vol_mv = ADC_MAX_VOLTAGE_MV_3300;

    {
        float off, rat;

        example_adc_calibration(cfg.vol10, cfg.vol25,
                                cfg.low_mv, cfg.high_mv, &off, &rat);
    }

    example_adc_vbat_fact_calib(cfg.vbat_mv, cfg.vbat_reg);

    if (SF32LB52X_LETTER_SERIES())
    {
#if defined(hwp_gpadc1)
        if (cfg.ldovref_flag)
            __HAL_ADC_SET_LDO_REF_SEL(&hadc, cfg.ldovref_sel);
#endif
    }

    return HAL_OK;
}

static float example_adc_get_float_mv(float value)
{
    float ratio;

    if (adc_range == 0)
        ratio = adc_vol_ratio / 3;
    else
        ratio = adc_vol_ratio;

    return (value - adc_vol_offset) * ratio / ADC_RATIO_ACCURATE;
}

void adc_init(void)
{
    ADC_ChannelConfTypeDef ADC_ChanConf;
    uint32_t lslot = ADC_DEV_CHANNEL;

    hadc.Instance = hwp_gpadc1;
    (void)utest_adc_calib();

    hadc.Init.data_samp_delay = 2;
    hadc.Init.conv_width = 75;
    hadc.Init.sample_width = 71;
    hadc.Init.adc_se = 1;
    hadc.Init.adc_force_on = 0;
    hadc.Init.atten3 = 0;
    hadc.Init.dma_en = 0;
    hadc.Init.en_slot = 0;
    hadc.Init.op_mode = 0;

    HAL_RCC_EnableModule(RCC_MOD_GPADC);
    HAL_ADC_Init(&hadc);
    HAL_Delay(300);

    rt_memset(&ADC_ChanConf, 0, sizeof(ADC_ChanConf));
    ADC_ChanConf.Channel = lslot;
    ADC_ChanConf.pchnl_sel = lslot;
    ADC_ChanConf.slot_en = 1;
    ADC_ChanConf.acc_num = 0;
    HAL_ADC_ConfigChannel(&hadc, &ADC_ChanConf);
    g_adc_slot = lslot;
}

float adc_read_battery_mv(void)
{
    HAL_StatusTypeDef ret = HAL_OK;
    uint32_t data[ADC_SW_AVRA_CNT];
    uint32_t total = 0;
    uint32_t temp;
    float mv;
    float fave;
    int i, j;

    HAL_ADC_Start(&hadc);

    for (i = 0; i < ADC_SW_AVRA_CNT; i++)
    {
        if (i != 0)
        {
            ADC_SET_UNMUTE(&hadc);
            HAL_Delay_us(200);
            __HAL_ADC_START_CONV(&hadc);
        }

        ret = HAL_ADC_PollForConversion(&hadc, 100);
        if (ret != HAL_OK)
        {
            HAL_ADC_Stop(&hadc);
            return -1.0f;
        }

        data[i] = (uint32_t)HAL_ADC_GetValue(&hadc, g_adc_slot);
        total += data[i];

        ADC_SET_MUTE(&hadc);
        rt_thread_delay(1);
    }

    HAL_ADC_Stop(&hadc);

    for (i = 0; i < ADC_SW_AVRA_CNT - 1; i++)
    {
        for (j = 0; j < ADC_SW_AVRA_CNT - 1 - i; j++)
        {
            if (data[j] > data[j + 1])
            {
                temp = data[j];
                data[j] = data[j + 1];
                data[j + 1] = temp;
            }
        }
    }

    total -= data[0];
    total -= data[ADC_SW_AVRA_CNT - 1];
    fave = (float)total / (ADC_SW_AVRA_CNT - 2);
    mv = example_adc_get_float_mv(fave);

    /* Channel 7 measures the half-scaled VBAT signal on 52X. */
    mv *= adc_vbat_factor;
    return mv;
}
