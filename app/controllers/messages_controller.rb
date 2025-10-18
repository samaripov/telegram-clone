class MessagesController < ApplicationController
  before_action :setup_init_variables
  def create
    @message = current_user.sent_messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.html { redirect_to chat_path(@receiver), notice: "sent" }
        format.turbo_stream { flash.now[:notice] = "sent" }
      end
      chat_id = @message.receiver.id
      # Send the message
      message_partial = ApplicationController.render(partial: "messages/message", locals: { message: @message, position: "left_position", animate: true })
      Turbo::StreamsChannel.broadcast_append_to("chat-#{chat_id}-messages", target: "messages", html: message_partial)

      # Update chats preview
      last_message_partial = ApplicationController.render(partial: "chats/last_message", locals: { text: @message.text, chat_id: chat_id })
      Turbo::StreamsChannel.broadcast_replace_to("chat-#{chat_id}-last-message-stream", target: "chat-#{chat_id}-last-message", html: last_message_partial)

    else
      respond_to do |format|
        format.html { redirect_to chat_path(@receiver), alert: "Unable to send message." }
        format.turbo_stream { flash.now[:notice] = "Unable to send message." }
      end
    end
  end

  private
    def setup_init_variables
      if params[:receiver_id]
        @receiver = Chat.find(params[:receiver_id])
        @messages = Message.where("((receiver_id = ? AND sender_id = ?) OR (sender_id = ? AND receiver_id = ?))", @receiver.id, current_user.id, @receiver.id, current_user.id)
      elsif message_params[:receiver_id]
        @receiver = Chat.find(message_params[:receiver_id])
        @messages = Message.where("((receiver_id = ? AND sender_id = ?) OR (sender_id = ? AND receiver_id = ?))", @receiver.id, current_user.id, @receiver.id, current_user.id)
      end
      @new_message = current_user.sent_messages.new
    end
    def message_params
      params.require(:message).permit(:text, :receiver_id, images: [])
    end
end
