require "test_helper"

class UploadedFileControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get uploaded_file_create_url
    assert_response :success
  end
end
