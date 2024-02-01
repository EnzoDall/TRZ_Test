require 'test_helper'

class SurvivorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get survivors_url
    assert_response :success
  end
end