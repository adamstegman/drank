# coding: UTF-8

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # name tests
  test "should require name" do
    assert Person.new.requires?(:name)
  end
  
  # drank tests
  test "should return the amount of this persons drinks" do
    adam = Person.find_or_create_by_name('Adam')
    aubrey = Person.find_or_create_by_name('Aubrey')
    Drink.new(:person => adam, :amount => 1).save!
    Drink.new(:person => adam, :amount => 1).save!
    Drink.new(:person => aubrey, :amount => 1).save!
    assert_equal 2, adam.drank
  end
  
  test "should return the amount of this persons drinks today" do
    adam = Person.find_or_create_by_name('Adam')
    y = Drink.new(:amount => 1, :person => adam,
                  :created_at => time_before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person => adam,
                  :created_at => time_at_new_day)
    t.save!
    mock_time_now(time_at_new_day)
    
    drank = adam.drank
    
    unmock_time_now
    
    assert_equal t.amount, drank
  end
  
  test "should return 0 if no drinks have occurred today" do
    adam = Person.find_or_create_by_name('Adam')
    assert_equal 0, adam.drank
  end
end
