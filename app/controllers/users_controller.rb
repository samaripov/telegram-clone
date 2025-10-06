class UsersController < ApplicationController
  def index
    if params[:username].present?
      @users = User.where("username ILIKE ?", "%#{params[:username]}%")
    end
  end

  def show
    messages = Message.where("receiver_id = ? OR sender_id = ?", current_user.id, current_user.id)
    friend_ids = messages.pluck(:sender_id, :receiver_id).flatten.uniq - [ current_user.id ]
    @friends = User.where(id: friend_ids)
  end
end
