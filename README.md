# Theproli FARM APPLICATION

# Description

- This application is the basic set for runing Laravel-React app in container
- All the technology included can be found in the docker-compose file the root directory of the project

## Backend

- **Laravel**

## Frontend

- **React**
- - Core issue can be solved by inspecting your network in the browser, check your response header
- - The response cookie you see is the setting inside the coreMiddleware file \app\Http\Middleware\CorsMiddleware.php
- - if your Access-Control-Allow-Origin: \* or your frond end url is in set to Access-Control-Allow-Origin; no cors issue

## Start App

- Run your docker
- Set your env config values
- Run docker compose up
