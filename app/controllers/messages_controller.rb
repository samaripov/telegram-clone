class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @new_message = current_user.sent_messages.new
  end

  def create
    @message = current_user.sent_messages.new(message_params)
    @new_message = current_user.sent_messages.new
    if @message.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "sent" }
        format.turbo_stream { flash.now[:notice] = "sent" }
      end
    else
      respond_to do |format|
        format.html { render :index, status: :unprocessable_content }
        format.turbo_stream { flash.now[:notice] = "Unable to send message." }
      end
    end
  end

  private
    def message_params
      params.require(:message).permit(:text)
    end
end
