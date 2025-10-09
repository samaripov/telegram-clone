class UsersController < ApplicationController
  def index
    if params[:username].present?
      @users = User.where("username ILIKE ?", "%#{params[:username]}%")
    end
  end

  def show
    @open_chats = current_user.open_chats
  end
end
