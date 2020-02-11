# Custom PHP images

All PHP images are based FROM official php repositories.
Where possible alpine version is used.

Base images come with `gd`, `intl`, `pdo`, `pdo_mysql`, `soap`, and `zip` extensions,
and [Composer](https://getcomposer.org/) preinstalled.

Dev images come with `xdebug` installed and enabled.

Image types:
- `cli` - basic PHP interpreter only
- `fpm` - exposes FPM server for PHP to be used as backend behind HTTP reverse proxy
- `nginx` - Nginx HTTP server with PHP FPM server integrated in single container (uses supervisord to orchestrate multiple daemon processes)