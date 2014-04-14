Segreto Server
==============

This is the API server for Segreto. To run your own instance, clone this 
repository, build its dependencies with `bundle install`, and run the server 
with `SEGRETO_SECRET_KEY=<your_key_here> rails server`. If you wish to modify 
the source or run a permanent instance of the server, we recommend storing your 
key variable in a `.env` file in the root of this repo and sourcing the file 
before each run with `export \`cat .env\``.

## API

The Segreto API is fairly simple, allowing only a few basic operations on the 
authenticated user's account and their stored secrets. The available operations 
are as follows:

### User operations

  * `POST /user`

    POST body:

        {
          "username": <username>,
          "password": <password>,
          "password_confirmation": <password>,
          "name": <name>,
          "email": <name>
        }

    Creates a new user from the posted parameters. The `name` and `email` fields 
    are optional. If the user is created successfully, the server responds with

        {
          "message": "Welcome, <username>!",
          "user": {
            "username": <username>,
            "email": <email>,
            "name": <name>,
            "remember_token": <big_base64_string>
          }
        }

    The new user will be logged in on the server and future requests must be 
    authenticated with the username and remember token in the query string or 
    post body.

    If the request fails for some reason, the server will respond with a message 
    indicating the reason and any further information it can provide.

  * `GET /user/signin?username=<username>&password=<password>`

    If the password is correct for the given username, then the server logs the 
    user in (if they were not already so) and responds with a greeting and their
    remember token:

        {
          "message": "Hello, <username>!",
          "remember_token": <big_base64_string>
        }

    Authentication failure will result in a message indicating that the supplied 
    credentials were invalid.

  * `GET /user/signout?username=<username>&remember_token=<token>`

  * `GET /user?username=<username>&remember_token=<token>`

    Returns the authenticated user's information.

        {
          "user": {
            "username": <username>,
            "email": <email>,
            "name": <name>,
            "remember_token": <big_base64_string>
          }
        }
