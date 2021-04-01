require "test_helper"

class TaskControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get task_create_url
    assert_response :success
  end

  test "should get update" do
    get task_update_url
    assert_response :success
  end

  test "should get destroy" do
    get task_destroy_url
    assert_response :success
  end

  test "should get list" do
    get task_list_url
    assert_response :success
  end
end
