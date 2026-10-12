#!/bin/bash
# Загрузка wheel-пакетов для изолированной установки (выполняется на узле с доступом к PyPI
# или внутреннему индексу). Хеши проверяются pip по файлам требований (--require-hashes).
# Результат: python/wheels/ (не хранится в git; публикуется во внутреннее хранилище артефактов).
set -Eeuo pipefail
cd "$(dirname "$0")/.."
PLATFORM="${PLATFORM:-manylinux2014_x86_64}"   # Debian 11 = glibc 2.31: допустимы manylinux до 2_31
PYVER="${PYVER:-3.9.2}"   # версия python3 в Debian 11
INDEX_ARGS=()
[[ -n "${PIP_INDEX_URL:-}" ]] && INDEX_ARGS=(--index-url "$PIP_INDEX_URL")
mkdir -p python/wheels
for req in python/requirements-ansible.txt python/requirements-backend.txt; do
  echo "загрузка: $req"
  python3 -m pip download --require-hashes --only-binary=:all: --no-deps \
    --python-version "$PYVER" --platform "$PLATFORM" --platform manylinux_2_17_x86_64 --platform manylinux_2_28_x86_64 --implementation cp \
    "${INDEX_ARGS[@]}" -d python/wheels -r "$req"
done
(cd python/wheels && sha256sum ./*.whl > SHA256SUMS)
echo "готово: $(find python/wheels -name '*.whl' | wc -l) пакетов"
