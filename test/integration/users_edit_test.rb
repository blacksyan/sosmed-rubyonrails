require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:ilham)
  end

  test "unsuccess edit process" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', email: 'email@invalid', password: 'password', password_confirmation: 'not match password'}}
    assert_template 'users/edit'
  end

  test "success edit process" do
    log_in_as(@user) 
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Adi Ilham'
    email = 'adi.ilham@gmail.com'
    patch user_path(@user), params: { user: { name: name, email: email, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "success edit when direct to edit page after login" do
    get edit_user_path(@user)
    log_in_as(@user) 
    assert_redirected_to edit_user_url(@user)
    name = 'Adi Ilham'
    email = 'adi.ilham@gmail.com'
    patch user_path(@user), params: { user: { name: name, email: email, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
