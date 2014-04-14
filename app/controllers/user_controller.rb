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
      render json: { message: "Welcome, #{@user.greet}!" }.merge(@user.as_json),
             status: :created 
    else
      fail_validation @user
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
      fail_validation @user
    end
  end

  # destroy(username, password, token)
  def destroy
    @user.destroy
    render json: { message: "We've removed your account. Bye!" }, status: :ok
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :email, :name)
  end
end
