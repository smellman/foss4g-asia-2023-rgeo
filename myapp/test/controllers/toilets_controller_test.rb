require "test_helper"

class ToiletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @toilet = toilets(:one)
  end

  test "should get index" do
    get toilets_url, as: :json
    assert_response :success
  end

  test "should create toilet" do
    assert_difference("Toilet.count") do
      post toilets_url, params: { toilet: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show toilet" do
    get toilet_url(@toilet), as: :json
    assert_response :success
  end

  test "should update toilet" do
    patch toilet_url(@toilet), params: { toilet: {  } }, as: :json
    assert_response :success
  end

  test "should destroy toilet" do
    assert_difference("Toilet.count", -1) do
      delete toilet_url(@toilet), as: :json
    end

    assert_response :no_content
  end
end
