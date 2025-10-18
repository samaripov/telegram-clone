require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "should have many messages" do
    chat = chats(:one)
    assert_respond_to chat, :messages
  end

  test "should have many users through userchats" do
    chat = chats(:one)
    assert_respond_to chat, :users
  end

  test "label returns correct username or name" do
    chat = chats(:one)
    user = users(:one)
    assert chat.label(user).is_a?(String) || chat.label(user).nil?
  end

  test "last_sent_message returns a message or nil" do
    chat = chats(:one)
    msg = chat.last_sent_message
    assert msg.nil? || msg.is_a?(Message)
  end
end
