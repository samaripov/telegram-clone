require "test_helper"

class UserchatTest < ActiveSupport::TestCase
  test "should belong to user" do
    userchat = userchats(:one)
    assert_respond_to userchat, :user
  end

  test "should belong to chat" do
    userchat = userchats(:one)
    assert_respond_to userchat, :chat
  end
end
