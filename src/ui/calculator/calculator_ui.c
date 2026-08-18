#include "calculator_ui.h"

#include <float.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ui/app_grid/app_grid_ui.h"

#define CALCULATOR_BG              0x050608
#define CALCULATOR_NUMBER          0x252A31
#define CALCULATOR_NUMBER_PRESSED  0x3A414B
#define CALCULATOR_FUNCTION        0xAEB5BF
#define CALCULATOR_FUNCTION_PRESS  0xD4D8DE
#define CALCULATOR_OPERATOR        0xF4A928
#define CALCULATOR_OPERATOR_PRESS  0xFFC95E
#define CALCULATOR_TEXT            0xF7F8FA
#define CALCULATOR_DARK_TEXT       0x111317
#define CALCULATOR_MUTED           0x7E8996
#define CALCULATOR_ENTRY_SIZE      24U
#define CALCULATOR_EXPRESSION_SIZE 64U

typedef enum
{
    CALCULATOR_KEY_0,
    CALCULATOR_KEY_1,
    CALCULATOR_KEY_2,
    CALCULATOR_KEY_3,
    CALCULATOR_KEY_4,
    CALCULATOR_KEY_5,
    CALCULATOR_KEY_6,
    CALCULATOR_KEY_7,
    CALCULATOR_KEY_8,
    CALCULATOR_KEY_9,
    CALCULATOR_KEY_CLEAR,
    CALCULATOR_KEY_BACKSPACE,
    CALCULATOR_KEY_PERCENT,
    CALCULATOR_KEY_DIVIDE,
    CALCULATOR_KEY_MULTIPLY,
    CALCULATOR_KEY_SUBTRACT,
    CALCULATOR_KEY_ADD,
    CALCULATOR_KEY_DECIMAL,
    CALCULATOR_KEY_EQUALS,
} calculator_key_t;

typedef enum
{
    CALCULATOR_OPERATOR_NONE,
    CALCULATOR_OPERATOR_ADD,
    CALCULATOR_OPERATOR_SUBTRACT,
    CALCULATOR_OPERATOR_MULTIPLY,
    CALCULATOR_OPERATOR_DIVIDE,
} calculator_operator_t;

typedef enum
{
    CALCULATOR_BUTTON_NUMBER,
    CALCULATOR_BUTTON_FUNCTION,
    CALCULATOR_BUTTON_OPERATOR,
} calculator_button_style_t;

lv_obj_t *ui_Calculator = NULL;

static lv_obj_t *calculator_expression_label;
static lv_obj_t *calculator_result_label;
static char calculator_entry[CALCULATOR_ENTRY_SIZE];
static double calculator_accumulator;
static double calculator_last_left;
static double calculator_last_operand;
static calculator_operator_t calculator_pending_operator;
static calculator_operator_t calculator_last_operator;
static uint8_t calculator_entry_active;
static uint8_t calculator_start_new_entry;
static uint8_t calculator_just_evaluated;
static uint8_t calculator_error;
static uint8_t calculator_apply(double left, double right,
                                calculator_operator_t operation,
                                double *result);


static void calculator_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static const char *calculator_operator_text(calculator_operator_t operation)
{
    switch (operation)
    {
    case CALCULATOR_OPERATOR_ADD:
        return "+";
    case CALCULATOR_OPERATOR_SUBTRACT:
        return "-";
    case CALCULATOR_OPERATOR_MULTIPLY:
        return "x";
    case CALCULATOR_OPERATOR_DIVIDE:
        return "/";
    default:
        return "";
    }
}

static uint8_t calculator_value_valid(double value)
{
    return value == value && value <= DBL_MAX && value >= -DBL_MAX;
}

static void calculator_format_value(double value, char *buffer, size_t size)
{
    if (value > -0.0000000001 && value < 0.0000000001)
        value = 0.0;
    (void)snprintf(buffer, size, "%.10g", value);
}

static const lv_font_t *calculator_large_font(size_t length)
{
    if (length > 16U)
        return &lv_font_montserrat_24;
    if (length > 12U)
        return &lv_font_montserrat_30;
    return &lv_font_montserrat_36;
}

static const lv_font_t *calculator_result_font(size_t length)
{
    if (length > 13U)
        return &lv_font_montserrat_30;
    if (length > 10U)
        return &lv_font_montserrat_36;
    return &lv_font_montserrat_48;
}

static void calculator_refresh_display(void)
{
    char expression[CALCULATOR_EXPRESSION_SIZE];
    char preview[CALCULATOR_ENTRY_SIZE + 4U];
    char left_text[CALCULATOR_ENTRY_SIZE];
    char preview_value[CALCULATOR_ENTRY_SIZE];
    double current;
    double result;

    expression[0] = '\0';
    preview[0] = '\0';
    if (calculator_error)
    {
        (void)snprintf(expression, sizeof(expression), "Invalid operation");
        (void)snprintf(preview, sizeof(preview), "Error");
    }
    else if (calculator_just_evaluated &&
             calculator_last_operator != CALCULATOR_OPERATOR_NONE)
    {
        char right_text[CALCULATOR_ENTRY_SIZE];

        calculator_format_value(calculator_last_left, left_text,
                                sizeof(left_text));
        calculator_format_value(calculator_last_operand, right_text,
                                sizeof(right_text));
        (void)snprintf(expression, sizeof(expression), "%s%s%s",
                       left_text,
                       calculator_operator_text(calculator_last_operator),
                       right_text);
        (void)snprintf(preview, sizeof(preview), "= %s", calculator_entry);
    }
    else
    {
        if (calculator_pending_operator == CALCULATOR_OPERATOR_NONE)
        {
            (void)snprintf(expression, sizeof(expression), "%s",
                           calculator_entry);
        }
        else
        {
            calculator_format_value(calculator_accumulator, left_text,
                                    sizeof(left_text));
            (void)snprintf(expression, sizeof(expression), "%s%s%s",
                           left_text,
                           calculator_operator_text(
                               calculator_pending_operator),
                           calculator_entry_active ? calculator_entry : "");
            if (calculator_entry_active &&
                strcmp(calculator_entry, "-") != 0)
            {
                current = strtod(calculator_entry, NULL);
                if (calculator_apply(calculator_accumulator, current,
                                     calculator_pending_operator, &result))
                {
                    calculator_format_value(result, preview_value,
                                            sizeof(preview_value));
                    (void)snprintf(preview, sizeof(preview), "= %s",
                                   preview_value);
                }
                else
                {
                    (void)snprintf(preview, sizeof(preview), "= Error");
                }
            }
        }
    }

    lv_label_set_text(calculator_expression_label, expression);
    lv_label_set_text(calculator_result_label, preview);
    if (calculator_just_evaluated || calculator_error)
    {
        lv_obj_set_pos(calculator_expression_label, 30, 20);
        lv_obj_set_size(calculator_expression_label, 330, 28);
        lv_obj_set_style_text_font(calculator_expression_label,
                                   &lv_font_montserrat_18,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_pos(calculator_result_label, 24, 50);
        lv_obj_set_size(calculator_result_label, 342, 64);
        lv_obj_set_style_text_font(
            calculator_result_label, calculator_result_font(strlen(preview)),
            LV_PART_MAIN | LV_STATE_DEFAULT);
    }
    else
    {
        lv_obj_set_pos(calculator_expression_label, 24, 24);
        lv_obj_set_size(calculator_expression_label, 342, 48);
        lv_obj_set_style_text_font(
            calculator_expression_label,
            calculator_large_font(strlen(expression)),
            LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_pos(calculator_result_label, 24, 75);
        lv_obj_set_size(calculator_result_label, 342, 32);
        lv_obj_set_style_text_font(calculator_result_label,
                                   &lv_font_montserrat_24,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
    }
}

static void calculator_reset(void)
{
    (void)snprintf(calculator_entry, sizeof(calculator_entry), "0");
    calculator_accumulator = 0.0;
    calculator_last_left = 0.0;
    calculator_last_operand = 0.0;
    calculator_pending_operator = CALCULATOR_OPERATOR_NONE;
    calculator_last_operator = CALCULATOR_OPERATOR_NONE;
    calculator_entry_active = 0U;
    calculator_start_new_entry = 1U;
    calculator_just_evaluated = 0U;
    calculator_error = 0U;
    if (calculator_expression_label != NULL)
        lv_label_set_text(calculator_expression_label, "");
    if (calculator_result_label != NULL)
        calculator_refresh_display();
}

static void calculator_show_error(void)
{
    (void)snprintf(calculator_entry, sizeof(calculator_entry), "Error");
    calculator_error = 1U;
    calculator_entry_active = 0U;
    calculator_start_new_entry = 1U;
    calculator_just_evaluated = 0U;
    calculator_pending_operator = CALCULATOR_OPERATOR_NONE;
    calculator_last_operator = CALCULATOR_OPERATOR_NONE;
    calculator_refresh_display();
}

static uint8_t calculator_apply(double left, double right,
                                calculator_operator_t operation,
                                double *result)
{
    switch (operation)
    {
    case CALCULATOR_OPERATOR_ADD:
        *result = left + right;
        break;
    case CALCULATOR_OPERATOR_SUBTRACT:
        *result = left - right;
        break;
    case CALCULATOR_OPERATOR_MULTIPLY:
        *result = left * right;
        break;
    case CALCULATOR_OPERATOR_DIVIDE:
        if (right == 0.0)
            return 0U;
        *result = left / right;
        break;
    default:
        *result = right;
        break;
    }
    return calculator_value_valid(*result);
}

static void calculator_begin_fresh_entry(void)
{
    if (calculator_error || calculator_just_evaluated)
        calculator_reset();
    if (calculator_start_new_entry || !calculator_entry_active)
    {
        calculator_entry[0] = '\0';
        calculator_entry_active = 1U;
        calculator_start_new_entry = 0U;
    }
}

static void calculator_input_digit(char digit)
{
    size_t length;

    calculator_begin_fresh_entry();
    length = strlen(calculator_entry);
    if (length == 1U && calculator_entry[0] == '0')
    {
        calculator_entry[0] = digit;
        calculator_entry[1] = '\0';
    }
    else if (length + 1U < sizeof(calculator_entry) && length < 15U)
    {
        calculator_entry[length] = digit;
        calculator_entry[length + 1U] = '\0';
    }
    calculator_refresh_display();
}

static void calculator_input_decimal(void)
{
    size_t length;

    calculator_begin_fresh_entry();
    if (strchr(calculator_entry, '.') != NULL)
        return;
    length = strlen(calculator_entry);
    if (strcmp(calculator_entry, "-") == 0)
    {
        calculator_entry[1] = '0';
        calculator_entry[2] = '.';
        calculator_entry[3] = '\0';
    }
    else if (length == 0U)
    {
        calculator_entry[0] = '0';
        calculator_entry[1] = '.';
        calculator_entry[2] = '\0';
    }
    else if (length + 1U < sizeof(calculator_entry))
    {
        calculator_entry[length] = '.';
        calculator_entry[length + 1U] = '\0';
    }
    calculator_refresh_display();
}

static void calculator_backspace(void)
{
    size_t length;

    if (calculator_error)
    {
        calculator_reset();
        return;
    }
    if (calculator_just_evaluated)
    {
        calculator_just_evaluated = 0U;
        calculator_last_operator = CALCULATOR_OPERATOR_NONE;
        calculator_entry_active = 1U;
        calculator_start_new_entry = 0U;
    }
    if (!calculator_entry_active)
    {
        if (calculator_pending_operator != CALCULATOR_OPERATOR_NONE)
        {
            calculator_pending_operator = CALCULATOR_OPERATOR_NONE;
            calculator_format_value(calculator_accumulator, calculator_entry,
                                    sizeof(calculator_entry));
            calculator_entry_active = 1U;
            calculator_start_new_entry = 0U;
            calculator_refresh_display();
        }
        return;
    }
    length = strlen(calculator_entry);
    if (length <= 1U ||
        (length == 2U && calculator_entry[0] == '-'))
    {
        (void)snprintf(calculator_entry, sizeof(calculator_entry), "0");
        if (calculator_pending_operator != CALCULATOR_OPERATOR_NONE)
        {
            calculator_entry_active = 0U;
            calculator_start_new_entry = 1U;
        }
        else
        {
            calculator_entry_active = 1U;
            calculator_start_new_entry = 0U;
        }
    }
    else
    {
        calculator_entry[length - 1U] = '\0';
    }
    calculator_refresh_display();
}

static void calculator_percent(void)
{
    double value;

    if (calculator_error)
        return;
    if (strcmp(calculator_entry, "-") == 0)
        return;
    value = strtod(calculator_entry, NULL) / 100.0;
    calculator_format_value(value, calculator_entry, sizeof(calculator_entry));
    calculator_entry_active = 1U;
    calculator_start_new_entry = 0U;
    calculator_just_evaluated = 0U;
    calculator_refresh_display();
}

static void calculator_choose_operator(calculator_operator_t operation)
{
    double current;
    double result;

    if (calculator_error)
        return;
    if (operation == CALCULATOR_OPERATOR_SUBTRACT &&
        calculator_start_new_entry && !calculator_entry_active)
    {
        (void)snprintf(calculator_entry, sizeof(calculator_entry), "-");
        calculator_entry_active = 1U;
        calculator_start_new_entry = 0U;
        calculator_just_evaluated = 0U;
        calculator_refresh_display();
        return;
    }
    if (strcmp(calculator_entry, "-") == 0)
        return;
    current = strtod(calculator_entry, NULL);
    if (calculator_pending_operator != CALCULATOR_OPERATOR_NONE &&
        calculator_entry_active)
    {
        if (!calculator_apply(calculator_accumulator, current,
                              calculator_pending_operator, &result))
        {
            calculator_show_error();
            return;
        }
        calculator_accumulator = result;
        calculator_format_value(result, calculator_entry,
                                sizeof(calculator_entry));
    }
    else if (calculator_pending_operator == CALCULATOR_OPERATOR_NONE)
    {
        calculator_accumulator = current;
    }

    calculator_pending_operator = operation;
    calculator_last_operator = CALCULATOR_OPERATOR_NONE;
    calculator_entry_active = 0U;
    calculator_start_new_entry = 1U;
    calculator_just_evaluated = 0U;
    calculator_refresh_display();
}

static void calculator_equals(void)
{
    calculator_operator_t operation;
    double left;
    double right;
    double result;

    if (calculator_error ||
        (calculator_entry_active && strcmp(calculator_entry, "-") == 0))
        return;
    if (calculator_pending_operator != CALCULATOR_OPERATOR_NONE)
    {
        operation = calculator_pending_operator;
        left = calculator_accumulator;
        right = calculator_entry_active ? strtod(calculator_entry, NULL) : left;
    }
    else if (calculator_just_evaluated &&
             calculator_last_operator != CALCULATOR_OPERATOR_NONE)
    {
        operation = calculator_last_operator;
        left = strtod(calculator_entry, NULL);
        right = calculator_last_operand;
    }
    else
    {
        return;
    }

    if (!calculator_apply(left, right, operation, &result))
    {
        calculator_show_error();
        return;
    }
    calculator_format_value(result, calculator_entry, sizeof(calculator_entry));
    calculator_accumulator = result;
    calculator_last_left = left;
    calculator_last_operand = right;
    calculator_last_operator = operation;
    calculator_pending_operator = CALCULATOR_OPERATOR_NONE;
    calculator_entry_active = 1U;
    calculator_start_new_entry = 1U;
    calculator_just_evaluated = 1U;
    calculator_refresh_display();
}

static void calculator_key_event(lv_event_t *event)
{
    calculator_key_t key;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    key = (calculator_key_t)(uintptr_t)lv_event_get_user_data(event);
    if (key >= CALCULATOR_KEY_0 && key <= CALCULATOR_KEY_9)
    {
        static const char digits[] = "0123456789";
        calculator_input_digit(digits[key - CALCULATOR_KEY_0]);
        return;
    }

    switch (key)
    {
    case CALCULATOR_KEY_CLEAR:
        calculator_reset();
        break;
    case CALCULATOR_KEY_BACKSPACE:
        calculator_backspace();
        break;
    case CALCULATOR_KEY_PERCENT:
        calculator_percent();
        break;
    case CALCULATOR_KEY_DIVIDE:
        calculator_choose_operator(CALCULATOR_OPERATOR_DIVIDE);
        break;
    case CALCULATOR_KEY_MULTIPLY:
        calculator_choose_operator(CALCULATOR_OPERATOR_MULTIPLY);
        break;
    case CALCULATOR_KEY_SUBTRACT:
        calculator_choose_operator(CALCULATOR_OPERATOR_SUBTRACT);
        break;
    case CALCULATOR_KEY_ADD:
        calculator_choose_operator(CALCULATOR_OPERATOR_ADD);
        break;
    case CALCULATOR_KEY_DECIMAL:
        calculator_input_decimal();
        break;
    case CALCULATOR_KEY_EQUALS:
        calculator_equals();
        break;
    default:
        break;
    }
}

static lv_obj_t *calculator_add_button(lv_coord_t x, lv_coord_t y,
                                       lv_coord_t width, const char *text,
                                       calculator_key_t key,
                                       calculator_button_style_t style)
{
    lv_obj_t *button = lv_btn_create(ui_Calculator);
    lv_obj_t *label = lv_label_create(button);
    uint32_t background = CALCULATOR_NUMBER;
    uint32_t pressed = CALCULATOR_NUMBER_PRESSED;
    uint32_t text_color = CALCULATOR_TEXT;
    const lv_font_t *label_font = &lv_font_montserrat_36;

    if (style == CALCULATOR_BUTTON_FUNCTION)
    {
        background = CALCULATOR_FUNCTION;
        pressed = CALCULATOR_FUNCTION_PRESS;
        text_color = CALCULATOR_DARK_TEXT;
        label_font = &lv_font_montserrat_24;
    }
    else if (style == CALCULATOR_BUTTON_OPERATOR)
    {
        background = CALCULATOR_OPERATOR;
        pressed = CALCULATOR_OPERATOR_PRESS;
    }

    lv_obj_set_pos(button, x, y);
    lv_obj_set_size(button, width, 56);
    lv_obj_clear_flag(button, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(button, 28, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(button, lv_color_hex(background),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(button, lv_color_hex(pressed),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(button, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(button, 0,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(button, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(button, calculator_key_event, LV_EVENT_CLICKED,
                        (void *)(uintptr_t)key);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, label_font,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(text_color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_center(label);
    return button;
}

void ui_Calculator_screen_init(void)
{
    static const struct
    {
        const char *text;
        calculator_key_t key;
        calculator_button_style_t style;
    } buttons[4][4] = {
        {{"AC", CALCULATOR_KEY_CLEAR, CALCULATOR_BUTTON_FUNCTION},
         {LV_SYMBOL_LEFT, CALCULATOR_KEY_BACKSPACE, CALCULATOR_BUTTON_FUNCTION},
         {"%", CALCULATOR_KEY_PERCENT, CALCULATOR_BUTTON_FUNCTION},
         {"/", CALCULATOR_KEY_DIVIDE, CALCULATOR_BUTTON_OPERATOR}},
        {{"7", CALCULATOR_KEY_7, CALCULATOR_BUTTON_NUMBER},
         {"8", CALCULATOR_KEY_8, CALCULATOR_BUTTON_NUMBER},
         {"9", CALCULATOR_KEY_9, CALCULATOR_BUTTON_NUMBER},
         {"x", CALCULATOR_KEY_MULTIPLY, CALCULATOR_BUTTON_OPERATOR}},
        {{"4", CALCULATOR_KEY_4, CALCULATOR_BUTTON_NUMBER},
         {"5", CALCULATOR_KEY_5, CALCULATOR_BUTTON_NUMBER},
         {"6", CALCULATOR_KEY_6, CALCULATOR_BUTTON_NUMBER},
         {"-", CALCULATOR_KEY_SUBTRACT, CALCULATOR_BUTTON_OPERATOR}},
        {{"1", CALCULATOR_KEY_1, CALCULATOR_BUTTON_NUMBER},
         {"2", CALCULATOR_KEY_2, CALCULATOR_BUTTON_NUMBER},
         {"3", CALCULATOR_KEY_3, CALCULATOR_BUTTON_NUMBER},
         {"+", CALCULATOR_KEY_ADD, CALCULATOR_BUTTON_OPERATOR}},
    };
    uint8_t row;
    uint8_t column;

    if (ui_Calculator != NULL)
        return;

    ui_Calculator = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_Calculator, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Calculator, lv_color_hex(CALCULATOR_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_Calculator, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);

    calculator_expression_label = lv_label_create(ui_Calculator);
    lv_obj_set_pos(calculator_expression_label, 30, 20);
    lv_obj_set_size(calculator_expression_label, 330, 28);
    lv_label_set_long_mode(calculator_expression_label, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_align(calculator_expression_label,
                                LV_TEXT_ALIGN_RIGHT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(calculator_expression_label,
                               &lv_font_montserrat_18,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(calculator_expression_label,
                                lv_color_hex(CALCULATOR_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    calculator_result_label = lv_label_create(ui_Calculator);
    lv_obj_set_pos(calculator_result_label, 24, 50);
    lv_obj_set_size(calculator_result_label, 342, 64);
    lv_label_set_long_mode(calculator_result_label, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_align(calculator_result_label, LV_TEXT_ALIGN_RIGHT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(calculator_result_label,
                                lv_color_hex(CALCULATOR_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    for (row = 0U; row < 4U; row++)
    {
        for (column = 0U; column < 4U; column++)
        {
            calculator_add_button((lv_coord_t)(27 + column * 86),
                                  (lv_coord_t)(130 + row * 63), 78,
                                  buttons[row][column].text,
                                  buttons[row][column].key,
                                  buttons[row][column].style);
        }
    }
    calculator_add_button(27, 382, 164, "0", CALCULATOR_KEY_0,
                          CALCULATOR_BUTTON_NUMBER);
    calculator_add_button(199, 382, 78, ".", CALCULATOR_KEY_DECIMAL,
                          CALCULATOR_BUTTON_NUMBER);
    calculator_add_button(285, 382, 78, "=", CALCULATOR_KEY_EQUALS,
                          CALCULATOR_BUTTON_OPERATOR);
    calculator_reset();
}

void ui_Calculator_screen_destroy(void)
{
    if (ui_Calculator != NULL)
        lv_obj_del(ui_Calculator);
    ui_Calculator = NULL;
    calculator_expression_label = NULL;
    calculator_result_label = NULL;
}

void ui_Calculator_open_from_app_grid(void)
{
    calculator_ui_wait_release();
    if (ui_Calculator == NULL)
        ui_Calculator_screen_init();
    lv_scr_load_anim(ui_Calculator, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Calculator_return(void)
{
    calculator_ui_wait_release();
    ui_AppGrid_open();
}
