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

    def remove_sdk_tls_certificate(items):
        filtered = []
        for item in items:
            if isinstance(item, list):
                filtered.append(remove_sdk_tls_certificate(item))
                continue
            path = getattr(item, 'abspath', str(item)).replace('\\', '/').lower()
            if path.endswith('/external/mbedtls_228/ports/src/tls_certificate.c'):
                continue
            filtered.append(item)
        return filtered

    objs = remove_sdk_tls_certificate(objs)
    certificate = os.path.abspath(os.path.join(
        os.path.dirname(__file__), '..', 'ota_client',
        'hsp_tls_certificate.c'
    ))
    certificate_object = env.Object(
        os.path.join(env['build_dir'], 'hsp_tls_certificate.o'),
        certificate
    )
    objs.extend(certificate_object)
    target = os.path.join(
        env['build_dir'], rtconfig.TARGET_NAME + '.' + rtconfig.TARGET_EXT
    )
    DoBuilding(target, objs)
    return env
