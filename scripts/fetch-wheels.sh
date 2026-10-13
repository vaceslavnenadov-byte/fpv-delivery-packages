#!/bin/bash
# Загрузка wheel-пакетов для изолированной установки (выполняется на узле с доступом к PyPI
# или внутреннему индексу). Хеши проверяются pip по файлам требований (--require-hashes).
# Результат: python/wheels/ (не хранится в git; публикуется во внутреннее хранилище артефактов).
set -Eeuo pipefail
cd "$(dirname "$0")/.."
PLATFORM="${PLATFORM:-manylinux2014_x86_64}"   # Debian 13 = glibc 2.41: допустимы manylinux до 2_41
PYVER="${PYVER:-3.13.5}"   # версия python3 в Debian 13
INDEX_ARGS=()
[[ -n "${PIP_INDEX_URL:-}" ]] && INDEX_ARGS=(--index-url "$PIP_INDEX_URL")
mkdir -p python/wheels
for req in python/requirements-ansible.txt python/requirements-backend.txt python/requirements-s3.txt; do
  echo "загрузка: $req"
  python3 -m pip download --require-hashes --only-binary=:all: --no-deps \
    --python-version "$PYVER" --platform "$PLATFORM" --platform manylinux_2_17_x86_64 --platform manylinux_2_28_x86_64 --platform manylinux_2_34_x86_64 --implementation cp \
    "${INDEX_ARGS[@]}" -d python/wheels -r "$req"
done
(cd python/wheels && sha256sum ./*.whl > SHA256SUMS)
echo "готово: $(find python/wheels -name '*.whl' | wc -l) пакетов"
