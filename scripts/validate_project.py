"""Validate source configuration and resource links without a HarmonyOS SDK.

Project .json5 files intentionally use the JSON subset so Python's standard
library suffices. This does not compile ArkTS or validate Huawei SDK schemas.
"""
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]


def validate():
    configs = {}
    for pattern in ('*.json', '*.json5'):
        for path in ROOT.rglob(pattern):
            if any(part in ('oh_modules', '.hvigor', 'build') for part in path.parts):
                continue
            configs[path] = json.loads(path.read_text(encoding='utf-8'))
    app_resources = ROOT / 'AppScope/resources/base'
    module_resources = ROOT / 'entry/src/main/resources/base'

    def has_resource(kind, name, bases):
        for base in bases:
            if kind in ('media', 'profile'):
                if any((base / kind).glob(name + '.*')):
                    return True
            else:
                for resource_file in (base / 'element').glob('*.json'):
                    for item in configs[resource_file].get(kind, []):
                        if item.get('name') == name:
                            return True
        return False

    for path in configs:
        bases = [app_resources] if 'AppScope' in path.parts else [module_resources, app_resources]
        for kind, name in re.findall(r'\$(string|color|media|profile):([\w]+)', path.read_text()):
            if not has_resource(kind, name, bases):
                raise ValueError(f'{path.relative_to(ROOT)}: missing {kind}:{name}')

    module_root = ROOT / 'entry/src/main'
    module = configs[module_root / 'module.json5']['module']
    assert module['name'] == 'entry'
    assert module['mainElement'] in [a['name'] for a in module['abilities']]
    for ability in module['abilities']:
        assert (module_root / ability['srcEntry']).is_file(), 'Missing ability source'
    pages = configs[module_resources / 'profile/main_pages.json']['src']
    for page in pages:
        source = module_root / 'ets' / (page + '.ets')
        assert source.is_file(), f'Missing page: {page}'
        assert '@Entry' in source.read_text(), f'Page lacks @Entry: {page}'
    ability_source = module_root / module['abilities'][0]['srcEntry']
    for loaded_page in re.findall(r"loadContent\('([^']+)'", ability_source.read_text()):
        assert loaded_page in pages, f'Unregistered page: {loaded_page}'
    build = configs[ROOT / 'build-profile.json5']
    assert build['modules'][0]['name'] == module['name']
    for product in build['app']['products']:
        assert product['runtimeOS'] == 'HarmonyOS'
    assert configs[ROOT / 'entry/build-profile.json5']['apiType'] == 'stageMode'
    for source in (module_root / 'ets').rglob('*.ets'):
        for imported in re.findall(r"from\s+'(\.[^']+)'", source.read_text()):
            assert (source.parent / (imported + '.ets')).is_file(), f'Missing import: {imported}'
        for kind, name in re.findall(r"\$r\('app\.(string|color|media)\.([\w]+)'\)", source.read_text()):
            assert has_resource(kind, name, [module_resources, app_resources])
    print(f'PASS: {len(configs)} configuration/resource files; entry, page and import links valid.')
    print('ArkTS compilation and device execution still require DevEco Studio + HarmonyOS SDK.')


if __name__ == '__main__':
    try:
        validate()
    except (ValueError, KeyError, AssertionError) as error:
        print(f'FAIL: {error}', file=sys.stderr)
        sys.exit(1)
