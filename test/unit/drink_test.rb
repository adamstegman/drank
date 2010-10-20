# coding: UTF-8

require 'test_helper'

class DrinkTest < ActiveSupport::TestCase
  setup :person
  
  # amount tests
  test "should require amount" do
    assert Drink.new.requires?(:amount)
  end
  
  # person tests
  test "should required person" do
    assert Drink.new.requires?(:person)
  end
  
  # this week scope tests
  test "should return drinks from this week if now is on or after Sunday on new day hour" do
    sunday = Date.today - Date.today.wday.days
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day(sunday))
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day(sunday))
    t.save!
    mock_time_now(time_at_new_day(sunday))
    
    this_weeks_drinks = Drink.from_this_week
    
    unmock_time_now
    
    assert_equal [t], this_weeks_drinks
  end
  
  test "should return drinks from last week if now is before new day hour" do
    sunday = Date.today - Date.today.wday.days
    last_sunday = sunday - 7.days
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day(last_sunday))
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day(last_sunday))
    t.save!
    mock_time_now(time_before_new_day(sunday))
    
    this_weeks_drinks = Drink.from_this_week
    
    unmock_time_now
    
    assert_equal [t], this_weeks_drinks
  end
  
  # today scope tests
  test "should return drinks from today if now is on or after new day hour" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day)
    t.save!
    mock_time_now(time_at_new_day)
    
    todays_drinks = Drink.from_today
    
    unmock_time_now
    
    assert_equal [t], todays_drinks
  end
  
  test "should return drinks from yesterday if now is before new day hour" do
    yesterday = Date.today - 1.day
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day(yesterday))
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day(yesterday))
    t.save!
    mock_time_now(time_before_new_day)

    todays_drinks = Drink.from_today
    
    unmock_time_now
    
    assert_equal [t], todays_drinks
  end
end
