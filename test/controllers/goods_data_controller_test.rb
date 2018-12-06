require 'test_helper'

class GoodsDataControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get goods_data_new_url
    assert_response :success
  end

  test "should get show" do
    get goods_data_show_url
    assert_response :success
  end

end
