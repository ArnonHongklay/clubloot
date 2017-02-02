require 'test_helper'

class SystemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get systems_index_url
    assert_response :success
  end

end
