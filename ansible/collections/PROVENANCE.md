# Происхождение архивов Ansible collections

Архивы собраны из официального дистрибутива `ansible==8.7.0` (PyPI), который содержит
указанные версии коллекций. Использовались только файлы, поставляемые в дистрибутиве
(без изменений содержимого):

| Архив | Коллекция | Версия | Источник |
|---|---|---|---|
| `ansible-posix-1.5.4.tar.gz` | ansible.posix | 1.5.4 | `ansible-8.7.0-py3-none-any.whl`, `ansible_collections/ansible/posix/` |
| `community-postgresql-2.4.3.tar.gz` | community.postgresql | 2.4.3 | `ansible-8.7.0-py3-none-any.whl`, `ansible_collections/community/postgresql/` |

SHA-256 исходного дистрибутива: `fa7d3bc2dfdb0ab031df645814ff86b15cb5ec041bfbee4041f795abfa5646ca`.

Архивы — это содержимое каталога коллекции (распаковываются в
`collections/ansible_collections/<namespace>/<name>/`, см. `install.sh --offline`).
Они не являются Galaxy-артефактами (дистрибутив PyPI не содержит тестов, перечисленных
в `FILES.json`), поэтому `ansible-galaxy collection install` к ним не применяется.
При наличии доступа к Galaxy коллекции устанавливаются по `requirements.yml` основного репозитория.

Лицензии: ansible.posix — GPL-3.0-or-later; community.postgresql — GPL-3.0-or-later.
