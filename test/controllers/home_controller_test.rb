require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get home_top_url
    assert_response :success
  end

  test "should get setting" do
    get home_setting_url
    assert_response :success
  end

  test "should get search" do
    get home_search_url
    assert_response :success
  end

end
