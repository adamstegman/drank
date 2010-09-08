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
    assert_equal Person.all, assigns(:people)
  end
  
  # add_drink tests
  test "should add drink if drank is nil" do
    person = Person.create(:name => "Adam")
    put :add_drink, :id => person
    assert_equal 1, Person.find(person).drank
  end
  
  test "should add drink to existing drank" do
    drank = 1
    person = Person.create(:name => "Adam", :drank => drank)
    put :add_drink, :id => person
    assert_equal drank + 1, Person.find(person).drank
  end
end
