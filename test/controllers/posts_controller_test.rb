require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:first_post)
  end

  test 'should redirect create when not login' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "Halo again" } }
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not login' do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy for not correct user' do
    log_in_as(users(:ilham))
    post = posts(:last_post)
    assert_no_difference 'Post.count' do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end
end
