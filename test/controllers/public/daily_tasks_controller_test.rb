require "test_helper"

class Public::DailyTasksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_daily_tasks_new_url
    assert_response :success
  end
end
