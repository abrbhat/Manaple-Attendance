require 'test_helper'

class LeavesControllerTest < ActionController::TestCase
  setup do
    @leave = leaves(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:leaves)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create leave" do
    assert_difference('Leave.count') do
      post :create, leave: {  }
    end

    assert_redirected_to leave_path(assigns(:leave))
  end

  test "should show leave" do
    get :show, id: @leave
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @leave
    assert_response :success
  end

  test "should update leave" do
    patch :update, id: @leave, leave: {  }
    assert_redirected_to leave_path(assigns(:leave))
  end

  test "should destroy leave" do
    assert_difference('Leave.count', -1) do
      delete :destroy, id: @leave
    end

    assert_redirected_to leaves_path
  end
end
