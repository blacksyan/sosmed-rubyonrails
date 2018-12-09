# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:ilham)
    @other_user = users(:adi)
  end

  test 'should get signup' do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not login' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when not login' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect index when not login' do
    get users_path
    assert_redirected_to login_url
  end
end
