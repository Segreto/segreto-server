Segreto Server
==============

This is the API server for Segreto. To run your own instance, clone this 
repository, build its dependencies with `bundle install`, and run the server 
with `SEGRETO_SECRET_KEY=<your_key_here> rails server`. If you wish to modify 
the source or run a permanent instance of the server, we recommend storing your 
key variable in a `.env` file in the root of this repo and sourcing the file 
before each run with ``export `cat .env` ``.

## Contents

  * [API](#api)
    * [User operations](#user-operations)
    * [Secret operations](#secret-operations)
  * [Development](#development)

## API

The Segreto API is fairly simple, allowing only a few basic operations on the 
authenticated user's account and their stored secrets. The available operations 
are as follows:

### User operations

  * Create: `POST /user`

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

  * Login: `GET /user/signin?username=<username>&password=<password>`

    If the password is correct for the given username, then the server logs the 
    user in (if they were not already so) and responds with a greeting and their
    remember token:

        {
          "message": "Hello, <username>!",
          "user": {
            "username": <username>,
            "email": <email>,
            "name": <name>,
            "remember_token": <big_base64_string>
          }
        }

    Authentication failure will result in a message indicating that the supplied 
    credentials were invalid.

    The `remember_token` should be retained by the client and used along with 
    the `username` for authenticating future requests. The current token can be 
    invalidated by making a signout request.

  * Logout: `GET /user/signout?username=<username>&remember_token=<token>`

    Logs out the current user, invalidating their `remember_token` on the 
    server.

  * Show current user: `GET /user?username=<username>&remember_token=<token>`

    Returns the authenticated user's information.

        {
          "user": {
            "username": <username>,
            "email": <email>,
            "name": <name>,
            "remember_token": <big_base64_string>
          }
        }

  * Update account information:
    `PATCH/PUT /user?username=<username>&remember_token=<token>`

    PATCH/PUT Body:

        {
          "name": <new_name>,
          "old_password": <old_password>,
          "email": <new_email>,
          "password": <new_password>,
          "password_confirmation": <new_password_confirmation>
        }

    Updates the specified fields with the supplied values. When changing the 
    password or email fields, one must also supply the correct current password.  
    The username field cannot be changed. On success, the resulting user object 
    will be returned in the same format as `GET /user` above.

  * Delete account: `DELETE /user?username=<username>&remember_token=<token>`
    
    Delete's the authenticated user's account.

### Secret operations

  * List a user's secrets:
    `GET /sercrets?username=<username>&remember_token=<token>`

    Returns a list of the user's secrets as key-value pairs:

        [
          {
            "key": <key>,
            "value": <value>,
            "client_iv": <client_iv>
          },
          ...
        ]

  * Lookup a specific secret:
    `GET /secret/:key?username=<username>&remember_token=<token>`

    Returns the key-value pair owned by the authenticated user matching the 
    given key.

        {
          "secret": {
            "key": <key>,
            "value": <value>,
            "client_iv": <client_iv>
          }
        }

  * Store a new secret:
    `POST /secret?username=<username>&remember_token=<token>`

    POST body:

        {
          "key": <key>,
          "value": <value>,
          "client_iv": <client_iv>
        }

    Given a new key-value pair, store them in the authenticated user's 
    collection of secrets.

    All three of the fields are to be arbitrary strings and will be encrypted at 
    rest in the Segreto database (We currently use 
    [attr_encryptor](https://github.com/danpal/attr_encryptor) for field 
    encryption.) For additional security, the official client will also encrypt 
    the value on the client side with a private key, making the stored values 
    entirely unknown to the server. The client_iv is stored server side so that 
    the client does not have to maintain a database of its own IVs for every 
    secret.

  * Update a secret:
    `PATCH/PUT /secret/:key?username=<username>&remember_token=<token>`

    PATCH body:

        {
          "value": <new_value>,
          "client_iv": <new_client_iv>
        }

    Updates the value field of the user's secret matching the given key to 
    `<new_value>`. If the client has chosen a new IV for the encrypted value, it 
    can supply the <new_client_iv> value as well. Note that changing the client 
    IV requires updating the value.

  * Delete a secret:
    `DELETE /secret/:key?username=<username>&remember_token=<token>`

    Permanently delete's the user's secret matching the given key.

## Development

If you want to modify the Segreto server source code, first make sure that you 
have Ruby 2.1.1 and the Bundle gem installed. If you don't already use a version 
manager, we recommend [rbenv](https://github.com/sstephenson/rbenv).

With that done, run the following:

    $ git clone https://github.com/segreto/segreto-server.git
    $ cd segreto-server/
    $ bundle install

Next, you need to generate a large, random string and store it in the 
`SEGRETO_SECRET_KEY` environment variable, preferably using a `.env` file whose 
contents should look like this:

    SEGRETO_SECRET_KEY=<some_big_random_string>

The file can then be sourced using ``export `cat .env` ``.

Finally start the server with

    $ rails server

or run the test suite with

    $ rake spec

If you want to contribute any of your changes, feel free to fork this repo and 
submit pull-requests!
