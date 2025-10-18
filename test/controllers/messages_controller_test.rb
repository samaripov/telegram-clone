require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @chat = chats(:one)
    sign_in @user
  end

  test "should create message and broadcast turbo stream" do
    assert_difference("Message.count") do
      post chat_messages_url(@chat), params: { message: { text: "Hello", receiver_id: @chat.id } }
    end
    assert_response :redirect
    follow_redirect!
    assert_select "div", /Hello/
  end

  test "should not create invalid message" do
    assert_no_difference("Message.count") do
      post chat_messages_url(@chat), params: { message: { text: "", receiver_id: @chat.id } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  # Turbo Stream test example
  test "should respond with turbo stream on create" do
    post chat_messages_url(@chat), params: { message: { text: "Turbo!", receiver_id: @chat.id } }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_match "turbo-stream", @response.body
  end
end
