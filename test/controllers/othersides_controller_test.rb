require 'test_helper'

class OthersidesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get othersides_show_url
    assert_response :success
  end

end
