require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", email: "invalid@email", password: "halo", password_confirmation: "1234"}}
    end
    assert_template 'users/signup'
  end

  test "valid signup process" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Ilham Adi", email: "valid@email.com", password: "halo1234", password_confirmation: "halo1234" } }
    end
  follow_redirect!
  assert_template 'users/show'
  end
end
