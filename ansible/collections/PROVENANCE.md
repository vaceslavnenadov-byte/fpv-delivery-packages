# Происхождение архивов Ansible collections

Архивы собраны из официального дистрибутива `ansible==14.5.0` (PyPI), который содержит
указанные версии коллекций. Использовались только файлы, поставляемые в дистрибутиве
(без изменений содержимого):

| Архив | Коллекция | Версия | Источник |
|---|---|---|---|
| `ansible-posix-2.2.2.tar.gz` | ansible.posix | 2.2.2 | `ansible-14.5.0-py3-none-any.whl`, `ansible_collections/ansible/posix/` |
| `community-postgresql-4.2.0.tar.gz` | community.postgresql | 4.2.0 | `ansible-14.5.0-py3-none-any.whl`, `ansible_collections/community/postgresql/` |

SHA-256 исходного дистрибутива: `245623ccc2d31d0f6f4bdb63168d550cad305fb032cc43d96e8f61ce8ab0ba84`.

Архивы — это содержимое каталога коллекции (распаковываются в
`collections/ansible_collections/<namespace>/<name>/`, см. `install.sh --offline`).
Они не являются Galaxy-артефактами (дистрибутив PyPI не содержит тестов, перечисленных
в `FILES.json`), поэтому `ansible-galaxy collection install` к ним не применяется.
При наличии доступа к Galaxy коллекции устанавливаются по `requirements.yml` основного репозитория.

Лицензии: ansible.posix — GPL-3.0-or-later; community.postgresql — GPL-3.0-or-later.
