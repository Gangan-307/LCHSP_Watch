set(SOURCES
    app/main.c
    drivers/adc.c
    drivers/display_power.c
    drivers/rgb.c
    drivers/vibrator.c
    services/battery_ui.c
    services/input_wake.c
    services/power_manager.c
    services/rtc.c
    services/time_sync.c
    services/wrist_wake.c
    bluetooth/battery_ble.c
    bluetooth/music_app.c
    bluetooth/pan.c
    ui/music/music_ui.c
    ui/generated/ui.c
    ui/generated/ui_events.c
    ui/generated/ui_helpers.c
    ui/generated/components/ui_comp_hook.c
    ui/generated/screens/ui_ScreenHome.c
    ui/generated/screens/ui_Screen1.c
    ui/generated/screens/ui_Screen2.c
    ui/generated/screens/ui_Screen3.c
    ui/generated/screens/ui_Screen4.c
    ui/generated/screens/ui_Screen5.c)

add_library(ui ${SOURCES})

target_include_directories(ui PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/app
    ${CMAKE_CURRENT_SOURCE_DIR}/drivers
    ${CMAKE_CURRENT_SOURCE_DIR}/services
    ${CMAKE_CURRENT_SOURCE_DIR}/bluetooth
    ${CMAKE_CURRENT_SOURCE_DIR}/ui/music
    ${CMAKE_CURRENT_SOURCE_DIR}/ui/generated)
