class UsersController < ApplicationController
  def index
    if params[:username].present?
      @users = User.where("username ILIKE ?", "%#{params[:username]}%")
    end
  end

  def show
    @friends = Message.where("receiver_id = ? OR sender_id = ?", current_user.id, current_user.id)
  end
end
