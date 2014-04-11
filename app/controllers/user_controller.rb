class UserController < ApplicationController
  before_filter :auth, except: [:create, :signin]

  # show(username)
  def show
    render json: @user
  end

  # create(username, password&/confirm, email, name)
  def create
    if @user = User.create(user_params)
      @user.create_token
      render json: @user, status: :created 
    else
      fail_validation
    end
  end

  # signin(username, password) -> token
  def signin
    @user = User.find_by username: params[:username]
    if @user.authenticate
      token = SecureRandom.urlsafe_base64
      @user.update(remember_token: token)
      render json: {remember_token: token}, status: :accepted
    else
      render json: {}, status: :forbidden
    end
  end

  # signout(username)
  def signout
    @user.update(remember_token: nil)
    render json: {}, status: :ok
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
    render json: {}, status: :ok
  end

  private

  # auth(username, token)
  def auth
    @user = User.find_by username: params[:username]
    if @user.remember_token && (@user.remember_token != params[:remember_token])
      render json: {}, status: :forbidden
    end
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
