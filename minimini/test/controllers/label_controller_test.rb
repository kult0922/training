require "test_helper"

class LabelControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get label_create_url
    assert_response :success
  end

  test "should get update" do
    get label_update_url
    assert_response :success
  end

  test "should get destroy" do
    get label_destroy_url
    assert_response :success
  end
end
