require 'test_helper'
require 'ostruct'

class UserTest < ActiveSupport::TestCase
  test "ensure api token expires after password change" do
    u = ::User.first
    assert !u.nil?

    req = OpenStruct.new
    req.headers = { }
    req.remote_ip = "192.168.1.100"
    req.user_agent = "Test User Agent"

    token = u.create_api_token("Test Runner", req)
    assert token
    assert token.token.to_s.size > 0

    ft = ::UserApiToken.where(:token => token.token).first()
    assert ft

    assert ft.token == token.token
    assert ft.user.id == u.id

    u.password = u.password_confirmation = "Password123Test123"
    assert u.save

    ft = ::UserApiToken.where(:token => token.token).first()
    assert ft.nil?
  end
end
