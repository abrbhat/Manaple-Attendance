require 'test_helper'

class AttendanceControllerTest < ActionController::TestCase
  test "should get mark" do
    get :mark
    assert_response :success
  end

  test "should get record" do
    get :record
    assert_response :success
  end

end
