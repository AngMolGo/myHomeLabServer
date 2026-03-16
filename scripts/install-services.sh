#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

for service in "$PROJECT_ROOT"/systemd/*.service.template; do
    name=$(basename "$service" .template)

    sed "s|{{PROJECT_ROOT}}|$PROJECT_ROOT|g" "$service" > "/tmp/$name"

    sudo install -m 644 "/tmp/$name" "/etc/systemd/system/$name"

    echo "Installed $name"
done

sudo systemctl daemon-reload

for service in "$PROJECT_ROOT"/systemd/*.service.template; do
    name=$(basename "$service" .template)

    sudo systemctl enable "$name"
    sudo systemctl restart "$name"

    echo "Restarted $name"
done