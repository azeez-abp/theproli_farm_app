#!/bin/bash

SCRIPT_PATH="${BASH_SOURCE%\\*}"

echo "${SCRIPT_PATH} is PATH"

 start_dbm(){
        has_sql_process=$(ps  | grep mysqld) 

        if [[ -z "${has_sql_process}" ]]; then
               # mysqld &
                # &=>background
                echo "DBMS started"
        else
                echo "MYsql DBMS has already running"
        fi

        sleep 2

        mysql -u root -p '' -P 3360 &
}
#start_dbm

checkService() {
    local service_name="$1"
    
    # >/dev/null: This part of the command redirects the standard
    # output (stdout) of the previous command to the "null device".
    if command -v "$service_name" > /dev/null 2>&1; then
        return 0  # Return 0 to indicate success
    else
        return 1  # Return 1 to indicate failure
    fi
}

if [[ ! -f "${SCRIPT_PATH}\\backend\\artisan\\vendor\\autoload.php" ]]; then 
    composer install
else 
    echo "Dependency already installed"
fi

if [[ ! -f "${SCRIPT_PATH}\\backend\\.env" ]]; then
    127.0.0.1
else   
        cp  "${SCRIPT_PATH}\\.env.local" "${SCRIPT_PATH}\\backend\\.env"
        echo ".env already set"
fi


#composer dump-autoload --working-dir="/var/www"
composer dump-autoload

 php "${SCRIPT_PATH}\\backend\\artisan" optimize
 php "${SCRIPT_PATH}\\backend\\artisan" key:generate
 
 php "${SCRIPT_PATH}\\backend\\artisan" route:clear

 php "${SCRIPT_PATH}\\backend\\artisan" route:cache

 php "${SCRIPT_PATH}\\backend\\artisan" config:clear

 php "${SCRIPT_PATH}\\backend\\artisan" config:cache

 php "${SCRIPT_PATH}\\backend\\artisan" view:clear

 php "${SCRIPT_PATH}\\backend\\artisan" view:cache

# remove this line if you do not want to run migrations on each build
 php "${SCRIPT_PATH}\\backend\\artisan" migrate 


echo "DEPLOYING ....."


# update application cache
php "${SCRIPT_PATH}\\backend\\artisan" optimize

# start the application
checkService "php"
php_exist=$?
if [ $php_exist -eq 0 ]; then
        echo "php started"
else
        echo "please install php"
fi
php-fpm -D 

#&&  nginx -g "daemon off;"

php "${SCRIPT_PATH}\\backend\\artisan" serve --host=127.0.0.1 --port=801 &

frontend="${SCRIPT_PATH}\\frontend\\"
echo "BACKEND READY"

cd $frontend 

npm start &
echo "FRONTEND READY"
#php-fpm -D
#nginx -g "daemon off;"

#php artisan serve  --host=0.0.0.0:801 --env=.env 

#exec dockert-php-entrypoint "$@"
#cp laravel_setup.sh ./backend/laravel_setup.sh