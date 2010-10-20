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
  
  # drank_from scope tests
  test "should return drinks on or after given time for drank_from" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day)
    t.save!
    
    drank_from = Drink.drank_from(time_at_new_day)
    assert_equal [t], drank_from
  end
  
  # drank_to scope tests
  test "should return drinks on or after given time for drank_to" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => time_at_new_day)
    t.save!
    
    drank_to = Drink.drank_to(time_before_new_day)
    assert_equal [y], drank_to
  end
  
  # this_week tests
  test "should return new day hour on Sunday from this week if now is on or after Sunday on new day hour" do
    sunday = Date.today - Date.today.wday.days
    mock_time_now(time_at_new_day(sunday))
    this_week = Drink.this_week
    unmock_time_now
    assert_equal time_at_new_day(sunday), this_week
  end
  
  test "should return new day hour from last week if now is before new day hour" do
    sunday = Date.today - Date.today.wday.days
    last_sunday = sunday - 7.days
    mock_time_now(time_before_new_day(sunday))
    this_week = Drink.this_week
    unmock_time_now
    assert_equal time_at_new_day(last_sunday), this_week
  end
  
  # today tests
  test "should return new day hour today if now is on or after new day hour" do
    mock_time_now(time_at_new_day)
    today = Drink.today
    unmock_time_now
    assert_equal time_at_new_day, today
  end
  
  test "should return new day hour yesterday if now is before new day hour" do
    yesterday = time_at_new_day - 1.day
    mock_time_now(time_before_new_day)
    today = Drink.today
    unmock_time_now
    assert_equal yesterday, today
  end
end
