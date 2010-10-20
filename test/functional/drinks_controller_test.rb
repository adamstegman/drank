# coding: UTF-8

require 'test_helper'

class DrinksControllerTest < ActionController::TestCase
  # index tests
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get drinks from today for index" do
    Person.find_or_create_by_name('Adam')
    today = Date.today
    new_day_hour = Drink::NEW_DAY_HOUR
    
    # mock Time.now
    Time.instance_eval do
      def today=(today)
        @today = today
      end
      
      def new_day_hour=(hour)
        @new_day_hour = hour
      end
      
      alias :old_now :now
      def now
        Time.local(@today.year, @today.month, @today.day, @new_day_hour - 1, 59, 59)
      end
    end
    Time.today = today
    Time.new_day_hour = new_day_hour
    
    y = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.local(today.year, today.month, today.day - 1, new_day_hour - 1, 59, 59))
    y.save!
    t = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.local(today.year, today.month, today.day - 1, new_day_hour, 0, 0))
    t.save!
    
    get :index
    
    # unmock Time.now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :today=
      undef :new_day_hour=
    end
    
    assert_equal [t], assigns(:drinks)
  end
  
  test "should get drinks sorted by created at ascending" do
    Person.find_or_create_by_name('Adam')
    today = Date.today
    new_day_hour = Drink::NEW_DAY_HOUR
    
    # mock Time.now
    Time.instance_eval do
      def today=(today)
        @today = today
      end
      
      def new_day_hour=(hour)
        @new_day_hour = hour
      end
      
      alias :old_now :now
      def now
        Time.local(@today.year, @today.month, @today.day, @new_day_hour - 1, 59, 59)
      end
    end
    Time.today = today
    Time.new_day_hour = new_day_hour
    
    y = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.local(today.year, today.month, today.day - 1, new_day_hour - 1, 59, 59))
    y.save!
    t2 = Drink.new(:amount => 1, :person_id => Person.first.id,
                   :created_at => Time.local(today.year, today.month, today.day - 1, new_day_hour, 0, 1))
    t2.save!
    t = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.local(today.year, today.month, today.day - 1, new_day_hour, 0, 0))
    t.save!
    
    get :index
    
    # unmock Time.now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :today=
      undef :new_day_hour=
    end
    
    assert_equal [t, t2], assigns(:drinks)
  end

  # create tests
  test "should create drink" do
    Person.find_or_create_by_name('Adam')
    assert_difference('Drink.count') do
      post :create, :drink => {:person_id => Person.first.to_param, :amount => "1"}
    end
  end
  
  test "should redirect to root after creating drink" do
    Person.find_or_create_by_name('Adam')
    post :create, :drink => {:person_id => Person.first.to_param, :amount => "1"}
    assert_redirected_to root_path
  end
end
