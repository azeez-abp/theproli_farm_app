#!/bin/bash

if [[ ! -f "./vendor/autoload.php" ]]; then 
    composer install
else 
    echo "Dependency already installed"
fi

if [[ ! -f ".env" ]]; then
    cp .env.example .env
else 
        echo ".env already set"
fi

 composer dump-autoload --working-dir="/var/www"

 php artisan optimize

 php artisan route:clear

 php artisan route:cache

 php artisan config:clear

 php artisan config:cache

 php artisan view:clear

 php artisan view:cache

# remove this line if you do not want to run migrations on each build
 php artisan migrate 


echo "DEPLOYING ....."


# update application cache
php artisan optimize

# start the application

php-fpm -D 

#&&  nginx -g "daemon off;"

php artisan serve --host=127.0.0.1 --port=8000

echo "DEPLOYMENT DONE"
#php-fpm -D
#nginx -g "daemon off;"

#php artisan serve  --host=0.0.0.0:801 --env=.env 

#exec dockert-php-entrypoint "$@"
#cp laravel_setup.sh ./backend/laravel_setup.sh