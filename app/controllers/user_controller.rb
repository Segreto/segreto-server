class UserController < ApplicationController
  before_filter :auth, except: [:create, :signin]

  # show(username)
  def show
    render json: @user
  end

  # create(username, password&/confirm, email, name)
  def create
    @new_user = 
      User.new(
        username: params[:username],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        email: params[:email],
        name: params[:name]
      )

    @new_user.save
    render json: @new_user, status: :created 
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
    if @user.remember_token != params[:remember_token]
      render json: {}, status: :forbidden
    end
  end
end
