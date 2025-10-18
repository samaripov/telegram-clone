require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "should not save message without text" do
    message = messages(:invalid)
    assert_not message.save, "Saved the message without text"
  end

  test "should save message with valid text" do
    message = messages(:one)
    assert message.valid?
  end

  test "should belong to sender and receiver" do
    message = messages(:one)
    assert_respond_to message, :sender
    assert_respond_to message, :receiver
  end

  test "can attach images" do
    message = messages(:one)
    assert_respond_to message, :images
  end
end
