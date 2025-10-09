class UsersController < ApplicationController
  def index
    if params[:username].present?
      @users = User.where("username ILIKE ?", "%#{params[:username]}%")
    end
  end

  def show
    @friends = current_user.friends
  end
end
