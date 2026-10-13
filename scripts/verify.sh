#!/bin/bash
# Проверка целостности репозитория пакетов перед публикацией и перед сборкой комплекта.
set -Eeuo pipefail
cd "$(dirname "$0")/.."
rc=0
echo "1. Контрольные суммы репозитория"
sha256sum --quiet --strict -c SHA256SUMS || rc=1
echo "2. Контрольные суммы коллекций"
(cd ansible/collections && sha256sum --quiet --strict -c SHA256SUMS) || rc=1
if [[ -f python/wheels/SHA256SUMS ]]; then
  echo "3. Контрольные суммы wheels"
  (cd python/wheels && sha256sum --quiet --strict -c SHA256SUMS) || rc=1
fi
echo "4. Все зависимости Python закреплены с хешами"
for f in python/requirements-*.txt; do
  if grep -E '^[A-Za-z0-9_.\[\]-]+' "$f" | grep -vqE '==[^ ]+ \\$'; then echo "  незакреплённая зависимость в $f"; rc=1; fi
  if ! grep -q -- '--hash=sha256:' "$f"; then echo "  нет хешей в $f"; rc=1; fi
done
echo "5. Отсутствие секретов"
if grep -rIEn --exclude-dir=.git --exclude-dir=wheels --exclude=verify.sh \
     '(BEGIN [A-Z ]*PRIVATE KEY|password\s*[:=]\s*\S+|AKIA[0-9A-Z]{16}|fpvd_[A-Za-z0-9_-]{20,})' . ; then
  echo "  обнаружены возможные секреты"; rc=1
fi
echo "6. Манифест Debian: формат строк"
if grep -vE '^\s*(#|$)' debian/trixie/packages.manifest | grep -vqE '^[a-z_]+\s+[a-z0-9.+-]+\s+(>=|<<|=)'; then
  echo "  некорректные строки манифеста"; rc=1
fi
(( rc == 0 )) && echo "OK: репозиторий пакетов $(cat VERSION) проверен" || echo "ОШИБКА: проверка не пройдена"
exit $rc
