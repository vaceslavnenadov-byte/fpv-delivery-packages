#!/bin/bash
# Проверка доступности пакетов манифеста и соответствия версий в чистом Debian 13.
# Запуск: docker run --rm -v "$PWD":/pkg -e MIRROR=http://deb.debian.org/debian debian:13 /pkg/scripts/check-debian13.sh
set -Eeuo pipefail
MIRROR="${MIRROR:-http://deb.debian.org/debian}"
SECURITY="${SECURITY:-http://security.debian.org/debian-security}"
rm -f /etc/apt/sources.list.d/debian.sources
cat > /etc/apt/sources.list.d/fpv-check.sources <<SRC
Types: deb
URIs: $MIRROR
Suites: trixie trixie-updates
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: $SECURITY
Suites: trixie-security
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
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
done < /pkg/debian/trixie/packages.manifest
exit $rc
