class UserController < ApplicationController
  before_filter :auth, except: [:create, :signin]

  def show
  end

  def create
  end

  def signin
  end

  def signout
  end

  def update
  end

  def destroy
  end

  private

  def auth
  end
end
