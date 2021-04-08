# Dia REST API server sample

[Dia](https://github.com/unger1984/dia) - a package for creating http / https servers in the Dart language.

This example was created in order to show how to create full-fledged REST API servers using Dia.

The `.env` file contains settings for accessing the database and the like. Accordingly, before starting the example, Postgres DB must be started.

## Technologies used

- Command-line arguments parsing
- .env configuration file
- Multithreading
- Simple sql migrations
- JsonWebToken

## Usage

- Install Dart following the instructions on the [official website](https://dart.dev/get-dart).
- Clone this repository. In the project directory, run `dart pub get`.
- Make sure that you have Postgres server running, and the required permissions are specified in the .env file
- Run `dart bin/launcher.dart -c 2`, where 2 is the number of server threads
- To check api, you can use Postman:
- - `POST /api/auth {"login": "test", "password": "test"}` - auth user
- - `GET /api/task (Authorization Bearer token)` - users tasks
- - `POST /api/task (Authorization Bearer token) {task}` - create user task
- - `PUT /api/task (Authorization Bearer token) {task}` - update user task
- - `DELETE /api/task (Authorization Bearer token) {task}` - delete user task
    
## WARNING

This is just an example! Much is not implemented here. For example, passwords are stored in clear text, the token is not checked for relevance, and much more.

Don't use it in production "as it is"!

## TODO

A little later, here I will add a link to an unwritten article on this example.

## Links

* [dia](https://github.com/unger1984/dia) - A simple dart http server in Koa2 style.
* [dia_router](https://github.com/unger1984/dia_router) - Package to route request as koa-router.
* [dia_cors](https://github.com/unger1984/dia_cors) - Package for CORS middleware.
* [dia_body](https://github.com/unger1984/dia_body) - Package with the middleware for parse request body.
* [dia_static](https://github.com/unger1984/dia_static) - Package to serving static files.

