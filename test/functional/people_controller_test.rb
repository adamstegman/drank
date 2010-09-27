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
    Person.create(:name => "Adam", :drank => 1)
    Person.create(:name => "Aubrey", :drank => 2)
    get :index, :format => 'json'
    assert_equal ActiveSupport::JSON.encode(Person.order('people.name DESC')), @response.body
  end
end
