#!/bin/bash
set -e

COMPOSER_INSTALLER_SRC_COMMIT='9481d183b908117c9742f9e4be4b26c6fb451cbe'
COMPOSER_INSTALLER_SHA384='756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3'

apt-get update
apt-get install -y --no-install-recommends git

curl -sSL -o composer-setup.php "https://raw.githubusercontent.com/composer/getcomposer.org/$COMPOSER_INSTALLER_SRC_COMMIT/web/installer"

echo "$COMPOSER_INSTALLER_SHA384  composer-setup.php" | sha384sum -c

php composer-setup.php --install-dir=/usr/bin --filename=composer
mv /usr/src/roundcubemail/composer.json-dist /usr/src/roundcubemail/composer.json

for pkg in $1 ; do
    composer \
        --working-dir=/usr/src/roundcubemail/ \
        --prefer-dist --prefer-stable \
        --no-update --no-interaction \
        --optimize-autoloader --apcu-autoloader \
        require \
        "$pkg"
done

composer \
    --working-dir=/usr/src/roundcubemail/ \
    --prefer-dist --no-dev \
    --no-interaction \
    --optimize-autoloader --apcu-autoloader \
    update
