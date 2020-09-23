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

file_env 'GOOGLE_OAUTH2_KEY'
file_env 'GOOGLE_OAUTH2_SECRET'

sed -i "s/GOOGLE_OAUTH2_KEY/$GOOGLE_OAUTH2_KEY/" config.yaml.defaults
sed -i "s/GOOGLE_OAUTH2_SECRET/$GOOGLE_OAUTH2_SECRET/" config.yaml.defaults




exec "$@"
