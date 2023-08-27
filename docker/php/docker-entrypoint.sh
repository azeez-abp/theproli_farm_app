#!/bin/bash
#the root dir in window is C:/Program Files
#//var/www/.env"
# Destination of env file inside container

#"C:\Users\BONJOUREX\Desktop\Code-project\project6\docker\php\"
checkService() {
    local service_name="$1"
    
    # >/dev/null: This part of the command redirects the standard
    # output (stdout) of the previous command to the "null device".
    if command -v "$service_name" >/dev/null 2>&1; then
        return 0  # Return 0 to indicate success
    else
        return 1  # Return 1 to indicate failure
    fi
}

# Call the function and store the exit status in a variable


# Loop through XDEBUG, PHP_IDE_CONFIG and REMOTE_HOST variables and check if they are set.
# If they are not set then check if we have values for them in the env file, if the env file exists. If we have values
# in the env file then add exports for these in in the ~./bashrc file.
# ENV_FILE="/var/www/.env"
# #ENV_FILE="/.env"


# for VAR in XDEBUG  REMOTE_HOST #PHP_IDE_CONFIG
# do
#   if [ -z "${!VAR}" ] && [ -f "${ENV_FILE}" ]; then
#     VALUE=$(grep $VAR $ENV_FILE | cut -d '=' -f 2-)
#     if [ ! -z "${VALUE}" ]; then
#       # Before adding the export we clear the value, if set, to prevent duplication.
#       sed -i "/$VAR/d"  ~/.bashrc
#       echo "export $VAR=$VALUE" >> ~/.bashrc;
#     fi
#   fi
# done



#If there is still no value for the REMOTE_HOST variable then we set it to the default of host.docker.internal. This
#value will be sufficient for windows and mac environments.
# if [ -z "${REMOTE_HOST}" ]; then
#   REMOTE_HOST="host.docker.internal"
#   sed -i "/REMOTE_HOST/d"  ~/.bashrc
#   echo "export REMOTE_HOST=\"$REMOTE_HOST\"" >> ~/.bashrc;
# fi

# echo "Current shell: $SHELL"
# # Source the .bashrc file so that the exported variables are available.
# . ~/.bashrc
# Start the cron service.
checkService 'service'
exit_status=$?

if [ "$exit_status" -eq 0 ]; then
    service cron start
fi


# Toggle xdebug
# if [ "true" == "$XDEBUG" ] && [ ! -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ]; then
#   # Remove PHP_IDE_CONFIG from cron file so we do not duplicate it when adding below
#   sed -i '/PHP_IDE_CONFIG/d' /etc/cron.d/laravel-scheduler
#   if [ ! -z "${PHP_IDE_CONFIG}" ]; then
#     # Add PHP_IDE_CONFIG to cron file. Cron by default does not load enviromental variables. The server name, set here, is
#     # used by PHPSTORM for path mappings
#     echo -e "PHP_IDE_CONFIG=\"$PHP_IDE_CONFIG\"\n$(cat /etc/cron.d/laravel-scheduler)" > /etc/cron.d/laravel-scheduler
#   fi
# #   # Enable xdebug estension and set up the docker-php-ext-xdebug.ini file with the required xdebug settings
#   docker-php-ext-enable xdebug && \
#   echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
#   echo "xdebug.start_with_request=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
#   echo "xdebug.discover_client_host=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
#   echo "xdebug.client_host.=$REMOTE_HOST" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini;

# elif [ -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ]; then
#   # Remove PHP_IDE_CONFIG from cron file if already added
#   sed -i '/PHP_IDE_CONFIG/d' /etc/cron.d/laravel-scheduler
#   # Remove Xdebug config file disabling xdebug
#   rm -rf /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# fi



if [[ ! -f ".env" ]]; then
    cp .env.example .env
else 
        echo ".env already set"
fi

if [[ ! -f "./vendor/autoload.php"  &&  ! -f "./composer.json" ]]; then 
    composer install
    composer dump-autoload --working-dir="/var/www"
else 
    echo "Dependency already installed"
fi

if [[ -f "./artisan" ]]; then 
  
 php artisan optimize

 php artisan route:clear

 php artisan route:cache

 php artisan config:clear

 php artisan config:cache

 php artisan view:clear

 php artisan view:cache

# remove this line if you do not want to run migrations on each build
 php artisan migrate 
else 
    echo "No Artisan file"
fi




echo "DEPLOYING ....."


# update application cache


# start the application

# php-fpm -D 

#&&  nginx -g "daemon off;"

#php artisan serve --host=127.0.0.1 --port=8000

echo "DEPLOYMENT DONE"
php-fpm -D
#nginx -g "daemon off;"
#open http://localhost:801

php artisan serve  --host=0.0.0.0:801 --env=.env 


#exec dockert-php-entrypoint "$@"
#cp laravel_setup.sh ./backend/laravel_setup.sh


#exec "$@"