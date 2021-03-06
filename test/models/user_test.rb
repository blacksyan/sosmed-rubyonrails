require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "halo1234", password_confirmation: "halo1234")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not more than 50 character" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not more than 255 character" do
    @user.email = "a" * 254 + "@email.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
    first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address} should be valid"
    end
  end

  test "email validation should reject invalid address" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
    foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_addresses.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have minimum length 8 chars" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "assosiated posts should be destroyed" do
    @user.save
    @user.posts.create!(content: "Halo again")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    ilham = users(:ilham)
    adi = users(:adi)
    assert_not ilham.following?(adi)
    ilham.follow(adi)
    assert ilham.following?(adi)
    assert adi.followers.include?(ilham)
    ilham.unfollow(adi)
    assert_not ilham.following?(adi)
  end

  test "feed should have the right posts" do
    ilham2 = users(:ilham2)
    adi2  = users(:adi2)
    ais    = users(:ais)
    # Posts from followed user
    ais.posts.each do |post_following|
      assert ilham2.feed.include?(post_following)
    end
    # Posts from self
    ilham2.posts.each do |post_self|
      assert ilham2.feed.include?(post_self)
    end
    # Posts from unfollowed user
    adi2.posts.each do |post_unfollowed|
      assert_not ilham2.feed.include?(post_unfollowed)
    end
  end
end
