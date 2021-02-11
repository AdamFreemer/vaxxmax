require "application_system_test_case"

class UpdateLogsTest < ApplicationSystemTestCase
  setup do
    @update_log = update_logs(:one)
  end

  test "visiting the index" do
    visit update_logs_url
    assert_selector "h1", text: "Update Logs"
  end

  test "creating a Update log" do
    visit update_logs_url
    click_on "New Update Log"

    fill_in "Task", with: @update_log.task
    click_on "Create Update log"

    assert_text "Update log was successfully created"
    click_on "Back"
  end

  test "updating a Update log" do
    visit update_logs_url
    click_on "Edit", match: :first

    fill_in "Task", with: @update_log.task
    click_on "Update Update log"

    assert_text "Update log was successfully updated"
    click_on "Back"
  end

  test "destroying a Update log" do
    visit update_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Update log was successfully destroyed"
  end
end
