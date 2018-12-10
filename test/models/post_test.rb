require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup 
    @user = users(:ilham)
    @post = @user.posts.build(content: "Lorem ipsum")
  end

  test 'should be valid' do
    assert @post.valid?
  end

  test 'user id should be present' do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test 'content should be present' do
    @post.content = '     '
    assert_not @post.valid?
  end

  test 'content should no more than 250 characters' do
    @post.content = 'a' * 251
    assert_not @post.valid?
  end

  test 'order should be the latest first' do
    assert_equal posts(:last_post), Post.first
  end
end
