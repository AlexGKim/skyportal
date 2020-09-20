#!/bin/bash

file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

file_env 'SKYPORTAL_DATABASE_USER'
file_env 'SKYPORTAL_DATABASE_PASSWORD'

sed -i "s/SKYPORTAL_DATABASE_USER/$SKYPORTAL_DATABASE_USER/" config.yaml
sed -i "s/SKYPORTAL_DATABASE_PASSWORD/$SKYPORTAL_DATABASE_PASSWORD/" config.yaml

exec "$@"
