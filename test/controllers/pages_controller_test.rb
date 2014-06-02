require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get main" do
    get :main
    assert_response :success
  end

  test "should get send_notification_mail" do
    get :send_notification_mail
    assert_response :success
  end

end
