class SecretController < ApplicationController
  before_filter :auth
  before_filter :set_secret, except: [:index, :create]

  def index
    render json: @user.secrets
  end

  def show
    render json: @secret.as_json(root: true)
  end

  def create
    @secret = Secret.create(secret_params)
    if @secret.valid?
      render json: { message: "Remembered a secret about #{@secret.key}." },
             status: :created
    else
      fail_validation @secret
    end
  end

  def update
    if @secret.update(secret_params)
      render json: @secret, status: :accepted
    else
      fail_validation @secret
    end
  end

  def destroy
    @secret.destroy
    render json: { message: "We've removed that secret!" }, status: :ok
  end

  private

  def set_secret
    @secret = @user.secrets.select { |s| s.key == params[:key] }.first
    unless @secret
      render json: { message: "No secret by that key here :(" },
             status: :not_found
    end
  end

  def secret_params
    params.slice(:key, :value)
      .permit(:key, :value)
      .merge(user_id: @user.id)
  end
end
