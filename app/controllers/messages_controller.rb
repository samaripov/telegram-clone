class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @new_message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      @new_message = Message.new
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
