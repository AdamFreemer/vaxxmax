require "test_helper"

class UpdateLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @update_log = update_logs(:one)
  end

  test "should get index" do
    get update_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_update_log_url
    assert_response :success
  end

  test "should create update_log" do
    assert_difference('UpdateLog.count') do
      post update_logs_url, params: { update_log: { task: @update_log.task } }
    end

    assert_redirected_to update_log_url(UpdateLog.last)
  end

  test "should show update_log" do
    get update_log_url(@update_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_update_log_url(@update_log)
    assert_response :success
  end

  test "should update update_log" do
    patch update_log_url(@update_log), params: { update_log: { task: @update_log.task } }
    assert_redirected_to update_log_url(@update_log)
  end

  test "should destroy update_log" do
    assert_difference('UpdateLog.count', -1) do
      delete update_log_url(@update_log)
    end

    assert_redirected_to update_logs_url
  end
end
