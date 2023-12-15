require "test_helper"

class Public::ChildrenControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_children_new_url
    assert_response :success
  end

  test "should get create" do
    get public_children_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_children_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_children_update_url
    assert_response :success
  end
end
