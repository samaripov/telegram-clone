class MessagesController < ApplicationController
  def chat
    @receiver = User.find(params[:receiver_id])
    @messages = Message.where("((receiver_id = ? AND sender_id = ?) OR (sender_id = ? AND receiver_id = ?))", @receiver.id, current_user.id, @receiver.id, current_user.id)
    @new_message = current_user.sent_messages.new
  end

  def create
    @message = current_user.sent_messages.new(message_params)
    @new_message = current_user.sent_messages.new
    @receiver = User.find(message_params[:receiver_id])

    if @message.save
      respond_to do |format|
        format.html { redirect_to chat_path(sender_id: current_user.id, receiver_id: @receiver.id), notice: "sent" }
        format.turbo_stream { flash.now[:notice] = "sent" }
      end
    else
      respond_to do |format|
        format.html { render :show, status: :unprocessable_content }
        format.turbo_stream { flash.now[:notice] = "Unable to send message." }
      end
    end
  end

  private
    def message_params
      params.require(:message).permit(:text, :receiver_id)
    end
end
