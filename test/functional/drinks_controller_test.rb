# coding: UTF-8

require 'test_helper'

class DrinksControllerTest < ActionController::TestCase
  setup :person
  
  # index tests
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get drinks from today by default for index" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day)
    t.save!
    mock_time_now(time_at_new_day)
    
    get :index
    
    unmock_time_now
    
    assert_equal [t], assigns(:drinks)
  end
  
  test "should get drinks sorted by created at ascending" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day)
    y.save!
    t2 = Drink.new(:amount => 1, :person_id => person.id,
                   :created_at => time_at_new_day + 1.second)
    t2.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day)
    t.save!
    mock_time_now(time_at_new_day + 1.second)
    
    get :index
    
    unmock_time_now
    
    assert_equal [t, t2], assigns(:drinks)
  end

  # create tests
  test "should create drink" do
    assert_difference('Drink.count') do
      post :create, :drink => {:person_id => person.to_param, :amount => "1"}
    end
  end
  
  test "should redirect to root after creating drink" do
    post :create, :drink => {:person_id => person.to_param, :amount => "1"}
    assert_redirected_to root_path
  end
end
