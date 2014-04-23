class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead of :exception.
  protect_from_forgery with: :null_session

  protected

  # auth(username, token)
  def auth
    unless params[:username] && params[:remember_token]
      fail_auth
    else
      @user = User.find_by username: params[:username]
      if !@user ||
         !@user.remember_token ||
         (@user.remember_token != params[:remember_token])
        fail_auth
      end
    end
  end

  def fail_auth
    render json: { error: "invalid credentials"}, status: :forbidden
  end

  def fail_validation record
    render json: { error: 'Failed validations',
                   validation_errors: record.errors.messages },
           status: :bad_request
  end
end
