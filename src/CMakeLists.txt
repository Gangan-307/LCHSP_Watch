SET(SOURCES screens/ui_ScreenHome.c
    screens/ui_Screen2.c
    screens/ui_Screen3.c
    screens/ui_Screen1.c
    screens/ui_Screen4.c
    ui.c
    components/ui_comp_hook.c
    ui_helpers.c
    images/ui_img_light_png.c
    images/ui_img_run_png.c
    images/ui_img_keyboard_png.c
    images/ui_img_setting_png.c
    images/ui_img_ui1_png.c)

add_library(ui ${SOURCES})
