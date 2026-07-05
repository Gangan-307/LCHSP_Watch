#!/bin/bash

WORK_PATH="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd)"
CURR_PATH="$(pwd)"
cd "$WORK_PATH"

JLinkExe -device SF32LB52X_NOR -CommandFile download.jlink

cd "$CURR_PATH"
