# Theproli FARM APPLICATION

# start your docker engine and docker-compose up

## Backend

- laravel

## Frontend

- React
- - Core issue can be solved by inspecting your network in the browser, check your reaponse header
- - The response cookie you see is the setting inside the coreMiddleware file \app\Http\Middleware\CorsMiddleware.php
- - if your Access-Control-Allow-Origin: \* or your frond end url is in set to Access-Control-Allow-Origin; no cors issue
