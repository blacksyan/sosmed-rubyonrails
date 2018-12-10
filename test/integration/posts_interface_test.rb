require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:ilham)
  end

  test 'post interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # valid submission
    content = "Halo there"
    assert_difference 'Post.count' do
      post posts_path, params: { post: { content: content } }
    end    
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # delete post
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1, per_page: 20).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # visit different user
    get user_path(users(:adi))
    assert_select 'a', text: 'delete', count: 0
  end
end
