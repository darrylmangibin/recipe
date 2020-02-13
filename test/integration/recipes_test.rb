require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end
end
