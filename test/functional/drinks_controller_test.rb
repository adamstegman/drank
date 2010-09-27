# coding: UTF-8

require 'test_helper'

class DrinksControllerTest < ActionController::TestCase
  # index tests
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drinks)
  end

  # new tests
  test "should get new" do
    get :new
    assert_response :success
  end

  # create tests
  test "should create drink" do
    assert_difference('Drink.count') do
      post :create, :drink => @drink.attributes
    end

    assert_redirected_to drink_path(assigns(:drink))
  end
end
