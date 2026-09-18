cmake_minimum_required(VERSION 3.16)
project(ui_lifecycle_test C)
enable_testing()
if(NOT EXISTS "${SIFLI_SDK}/external/lvgl_v8/lvgl.h")
    message(FATAL_ERROR "Set SIFLI_SDK to the SiFli SDK directory")
endif()
set(CMAKE_C_STANDARD 11)
set(LVGL_DIR "${SIFLI_SDK}/external/lvgl_v8")
set(APP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../src")
file(GLOB_RECURSE LVGL_SOURCES "${LVGL_DIR}/src/*.c")
# Disabled snapshots still include target-only allocation headers in this SDK.
list(FILTER LVGL_SOURCES EXCLUDE REGEX "/snapshot/lv_snapshot\\.c$")
add_executable(ui_lifecycle_test ${LVGL_SOURCES} test_bluetooth.c
    "${APP_DIR}/ui/generated/screens/ui_BluetoothSettings.c"
    "${APP_DIR}/ui/generated/ui_screen_lifecycle.c"
    "${APP_DIR}/ui/generated/ui_swipe_back.c"
    "${APP_DIR}/ui/generated/hsp_font_cjk_22.c")
target_include_directories(ui_lifecycle_test PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}" "${LVGL_DIR}" "${LVGL_DIR}/src" "${APP_DIR}"
    "${SIFLI_SDK}/middleware/lvgl")
target_compile_options(ui_lifecycle_test PRIVATE -g -fsanitize=address,undefined
    -fno-omit-frame-pointer)
target_link_options(ui_lifecycle_test PRIVATE -fsanitize=address,undefined)
target_link_libraries(ui_lifecycle_test PRIVATE m)
add_test(NAME bluetooth_lifecycle COMMAND ui_lifecycle_test)
