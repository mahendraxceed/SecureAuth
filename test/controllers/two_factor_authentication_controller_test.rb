require "test_helper"

class TwoFactorAuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get two_factor_authentication_index_url
    assert_response :success
  end

  test "should get enable" do
    get two_factor_authentication_enable_url
    assert_response :success
  end

  test "should get confirm" do
    get two_factor_authentication_confirm_url
    assert_response :success
  end

  test "should get disable" do
    get two_factor_authentication_disable_url
    assert_response :success
  end
end
