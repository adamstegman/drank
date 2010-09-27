# coding: UTF-8

require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  # index tests
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get all people with index" do
    Person.create(:name => "Adam")
    Person.create(:name => "Aubrey")
    get :index
    assert_equal Person.order('people.name DESC'), assigns(:people)
  end
  
  test "should respond with JSON array" do
    Person.create(:name => "Adam")
    Person.create(:name => "Aubrey")
    get :index, :format => 'json'
    assert_equal Person.order('people.name DESC').to_json(:methods => :drank), @response.body
  end
end
