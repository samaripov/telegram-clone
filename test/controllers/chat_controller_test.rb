require "test_helper"

class ChatControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @chat = chats(:one)
    sign_in @user
  end

  test "should get show" do
    get chat_url(@chat)
    assert_response :success
  end

  test "should render turbo stream for chat" do
    get chat_url(@chat), headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_match "turbo-stream", @response.body
  end

  # Tests for create action
  test "should create new chat when no existing chat between users" do
    # Use a fixture instead of creating a new user (avoids Devise validations here)
    new_user = users(:three)

    assert_difference("Chat.count") do
      assert_difference("Userchat.count", 2) do # Two userchats created (one for each user)
        post chats_url, params: { user_ids: [ @user.id, new_user.id ] }
      end
    end

    assert_response :redirect
    created_chat = Chat.last
    assert_redirected_to chat_path(created_chat)

    # Verify both users are associated with the chat
    assert_includes created_chat.users, @user
    assert_includes created_chat.users, new_user
  end

  test "should create new chat with initial message" do
    new_user = users(:four)
    initial_text = "Hello, this is the first message!"

    assert_difference("Chat.count") do
      assert_difference("Message.count") do
        post chats_url, params: {
          user_ids: [ @user.id, new_user.id ],
          text: initial_text
        }
      end
    end

    created_chat = Chat.last
    message = Message.last
    assert_equal initial_text, message.text
    assert_equal @user, message.sender
    assert_equal created_chat, message.receiver
  end

  test "should redirect to existing chat when users already have a shared chat" do
    # Ensure the users already have a shared chat
    existing_chat = @chat

    assert_no_difference("Chat.count") do
      post chats_url, params: { user_ids: [ @user.id, @other_user.id ] }
    end

    assert_response :redirect
    assert_redirected_to chat_path(existing_chat)
  end

  test "should add initial message to existing chat when provided" do
    initial_text = "Adding message to existing chat"

    assert_no_difference("Chat.count") do
      assert_difference("Message.count") do
        post chats_url, params: {
          user_ids: [ @user.id, @other_user.id ],
          text: initial_text
        }
      end
    end

    message = Message.last
    assert_equal initial_text, message.text
    assert_equal @user, message.sender
  end

  test "should handle chat creation failure gracefully" do
    # Mock Chat.new to return an invalid chat
    invalid_chat = Chat.new
    invalid_chat.errors.add(:base, "Something went wrong")

    Chat.stub :new, invalid_chat do
      invalid_chat.stub :save, false do
        new_user = users(:five)

        assert_no_difference("Chat.count") do
          post chats_url, params: { user_ids: [ @user.id, new_user.id ] }
        end

        assert_response :redirect
        assert_redirected_to root_path
        assert_match "Something went wrong", flash[:alert]
      end
    end
  end

  test "should create chat with multiple users" do
    user3 = users(:three)
    user4 = users(:four)

    assert_difference("Chat.count") do
      assert_difference("Userchat.count", 3) do # Three users in the chat
        post chats_url, params: { user_ids: [ @user.id, user3.id, user4.id ] }
      end
    end

    created_chat = Chat.last
    assert_equal 3, created_chat.users.count
    assert_includes created_chat.users, @user
    assert_includes created_chat.users, user3
    assert_includes created_chat.users, user4
  end

  test "should not create duplicate userchats for existing shared chat with multiple users" do
    # First create a chat with 3 users
    user3 = users(:three)
    existing_chat = Chat.create!
    [ @user, @other_user, user3 ].each do |user|
      Userchat.create!(user: user, chat: existing_chat)
    end

    # Try to create the same chat again
    assert_no_difference("Chat.count") do
      assert_no_difference("Userchat.count") do
        post chats_url, params: { user_ids: [ @user.id, @other_user.id, user3.id ] }
      end
    end

    assert_response :redirect
    assert_redirected_to chat_path(existing_chat)
  end

  # Tests for new action
  test "should redirect to existing chat in new action when users already have shared chat" do
    get new_chat_url, params: { receiver_id: @other_user.id }
    assert_response :redirect
    assert_redirected_to chat_path(@chat)
  end

  test "should render new template when no existing chat found" do
    new_user = users(:four)
    get new_chat_url, params: { receiver_id: new_user.id }
    assert_response :success
    assert_select "h4.chat_title", text: new_user.username
  end
end
