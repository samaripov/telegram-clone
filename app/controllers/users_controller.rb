class UsersController < ApplicationController
  def index
    if params[:username].present?
      @users = User.where("username LIKE ?", "%#{params[:username]}%")
    end
  end
end
