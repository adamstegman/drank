# coding: UTF-8

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # name tests
  test "should require name" do
    assert Person.new.requires?(:name)
  end
  
  # drank tests
  test "should return the amount of this persons drinks" do
    adam = person('Adam')
    aubrey = person('Aubrey')
    Drink.new(:person => adam, :amount => 1).save!
    Drink.new(:person => adam, :amount => 1).save!
    Drink.new(:person => aubrey, :amount => 1).save!
    assert_equal 2, adam.drank
  end
  
  test "should return the amount of this persons drinks today" do
    y = Drink.new(:amount => 1, :person => person,
                  :created_at => Time.before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person => person,
                  :created_at => Time.at_new_day)
    t.save!
    Time.mock_now(Time.at_new_day)
    
    drank = person.drank
    
    Time.unmock_now
    
    assert_equal t.amount, drank
  end
  
  test "should return 0 if no drinks have occurred today" do
    assert_equal 0, person.drank
  end
end
