require 'test_helper'

class TradeAccountDictsControllerTest < ActionDispatch::IntegrationTest
  test "should get position_status:integer" do
    get trade_account_dicts_position_status:integer_url
    assert_response :success
  end

  test "should get trade_type:referencecs" do
    get trade_account_dicts_trade_type:referencecs_url
    assert_response :success
  end

  test "should get account:references" do
    get trade_account_dicts_account:references_url
    assert_response :success
  end

end
