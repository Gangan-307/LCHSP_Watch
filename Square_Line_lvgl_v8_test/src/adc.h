#ifndef LCHSPI_ADC_H_INCLUDED
#define LCHSPI_ADC_H_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif

void adc_init(void);
float adc_read_battery_mv(void);

#ifdef __cplusplus
}
#endif

#endif
