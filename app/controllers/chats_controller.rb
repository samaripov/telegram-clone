class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
    @users = @chat.users
  end
  def new
    @user = User.find(params[:receiver_id])
  end
  def create
    user_ids = params[:user_ids].map(&:to_i)
    users = user_ids.map { |id| User.find(id.to_i) }
    @chat = Chat.new()

    # Find all chats that current users are in.
    # If it doesn't exist make a new chat.
    userchats = users_shared_chats(user_ids)

    if userchats.any?
      @chat = Chat.find(userchats[0].chat_id)
      redirect_to @chat
    elsif @chat.save
      # Create associations between users and chats
      users.each do |user|
        Userchat.create(user: user, chat: @chat)
      end
      # Broadcast the chat to everyone in the chat but the current user
      (users - [ current_user ]).each do |user|
        chat_partial = ApplicationController.render(partial: "chats/chat", locals: { chat: @chat, label: current_user.username })
        Turbo::StreamsChannel.broadcast_append_to("#{user.id}-chats", target: "users-chats", html: chat_partial)
      end
      redirect_to @chat
    else
      flash[:alert] = @chat.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end

  private
    def users_shared_chats(user_ids, number_of_users = 2)
      Userchat
        .select(:chat_id)
        .where(user_id: user_ids)
        .group(:chat_id)
        .having("COUNT(DISTINCT user_id) = ?", number_of_users)
    end
end
