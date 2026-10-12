#!/bin/bash
# Проверка доступности пакетов манифеста и соответствия версий в чистом Debian 11.
# Запуск: docker run --rm -v "$PWD":/pkg -e MIRROR=http://deb.debian.org/debian debian:11 /pkg/scripts/check-debian11.sh
set -Eeuo pipefail
MIRROR="${MIRROR:-http://deb.debian.org/debian}"
SECURITY="${SECURITY:-http://security.debian.org/debian-security}"
cat > /etc/apt/sources.list <<SRC
deb $MIRROR bullseye main
deb $MIRROR bullseye-updates main
deb $SECURITY bullseye-security main
SRC
apt-get update -qq
rc=0
while read -r group pkg constraint; do
  [[ -z "$group" || "$group" == \#* ]] && continue
  cand="$(apt-cache policy "$pkg" | awk '/Candidate:/ {print $2}')"
  if [[ -z "$cand" || "$cand" == "(none)" ]]; then echo "НЕТ ПАКЕТА: $pkg ($group)"; rc=1; continue; fi
  IFS=',' read -ra parts <<< "$constraint"
  for part in "${parts[@]}"; do
    read -r op ver <<< "$part"
    case "$op" in
      ">=") dpkg --compare-versions "$cand" ge "$ver" || { echo "ВЕРСИЯ: $pkg $cand не $op $ver"; rc=1; } ;;
      "<<") dpkg --compare-versions "$cand" lt "$ver" || { echo "ВЕРСИЯ: $pkg $cand не $op $ver"; rc=1; } ;;
    esac
  done
  echo "ok $pkg $cand"
done < /pkg/debian/bullseye/packages.manifest
exit $rc
