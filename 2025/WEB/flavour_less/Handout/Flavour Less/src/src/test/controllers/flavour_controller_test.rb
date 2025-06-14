require "test_helper"

class FlavourControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get flavour_index_url
    assert_response :success
  end
end
