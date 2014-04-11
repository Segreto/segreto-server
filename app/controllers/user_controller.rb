class UserController < ApplicationController
  before_filter :auth, except: [:create, :signin]

  # show(username)
  def show
    render json: @user
  end

  # create(username, password&/confirm, email, name)
  def create
    @user = User.create(user_params)
    if @user.valid?
      @user.create_token
      render json: @user.as_json
                     .reverse_merge(message: "Welcome, #{@user.greet}!"),
             status: :created 
    else
      fail_validation
    end
  end

  # signin(username, password) -> token
  def signin
    @user = User.find_by username: params[:username]
    if @user && @user.authenticate(params[:password])
      @user.create_token
      render json: { message: "Hello, #{@user.greet}!",
                     remember_token: @user.remember_token },
             status: :accepted
    else
      fail_auth
    end
  end

  # signout(username)
  def signout
    @user.update(remember_token: nil)
    render json: { message: "bye!" }, status: :ok
  end

  # update(username, attr*, val*)
  def update
    if @user.update(user_params)
      render json: @user, status: :accepted
    else
      fail_validation
    end
  end

  # destroy(username, password, token)
  def destroy
    @user.destroy
    render json: { message: "We've removed your account. Bye!" }, status: :ok
  end

  private

  # auth(username, token)
  def auth
    fail_auth unless params[:username] && params[:remember_token]
    @user = User.find_by username: params[:username]
    if !@user ||
       !@user.remember_token ||
       (@user.remember_token != params[:remember_token])
      fail_auth
    end
  end

  def fail_auth
    render json: { error: "invalid credentials"}, status: :forbidden
  end

  def user_params
    params.permit(:username, :password, :password_confirmation, :email, :name)
  end

  def fail_validation
    render json: { error: 'Failed validations',
                   validation_errors: @user.errors.messages },
           status: :bad_request
  end
end
