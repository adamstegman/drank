require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get all people with index" do
    Person.create(:name => "Adam")
    Person.create(:name => "Aubrey")
    get :index
    assert_equal Person.all, assigns(:people)
  end
end
