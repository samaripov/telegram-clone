require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user with invalid username" do
    user = User.new(username: "invalid username!", email: "test@example.com", password: "password")
    assert_not user.save, "Saved the user with invalid username"
  end

  test "should save user with valid username" do
    user = User.new(username: "valid_username", email: "test2@example.com", password: "password")
    assert user.valid?
  end

  test "should have many chats through userchats" do
    user = users(:one)
    assert_respond_to user, :chats
  end
end
