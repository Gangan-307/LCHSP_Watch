import os
import rtconfig
from building import *


def create_env(proj_path=None):
    sifli_sdk = os.getenv('SIFLI_SDK')
    if not sifli_sdk:
        print('SIFLI_SDK is not configured.')
        exit()

    if not GetDepend('SOC_SF32LB52X'):
        AddChildProj('lcpu', '../lcpu', True, core='LCPU')
    else:
        AddLCPU(sifli_sdk, rtconfig.CHIP)

    SifliEnv(proj_path)
    if os.getenv('RTT_CC') == 'gcc':
        rtconfig.CFLAGS += ' -Wno-error=incompatible-pointer-types'


def build(env=None):
    objs = PrepareBuilding(env)
    env = GetCurrentEnv()
    target = os.path.join(
        env['build_dir'], rtconfig.TARGET_NAME + '.' + rtconfig.TARGET_EXT
    )
    DoBuilding(target, objs)
    return env
