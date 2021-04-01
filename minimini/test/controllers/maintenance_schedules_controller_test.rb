require "test_helper"

class MaintenanceSchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get maintenance_schedules_create_url
    assert_response :success
  end

  test "should get update" do
    get maintenance_schedules_update_url
    assert_response :success
  end

  test "should get destroy" do
    get maintenance_schedules_destroy_url
    assert_response :success
  end
end
