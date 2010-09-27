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
    today = Date.today
    
    # mock Time.now
    Time.instance_eval do
      def today=(today)
        @today = today
      end
      
      alias :old_now :now
      def now
        Time.gm(@today.year, @today.month, @today.day, Drink::NEW_DAY_HOUR, 0, 0)
      end
    end
    Time.today = today
    
    y = Drink.new(:amount => 1, :person => adam,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR - 1, 59, 59))
    y.save!
    t = Drink.new(:amount => 1, :person => adam,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR, 0, 0))
    t.save!
    
    drank = adam.drank
    
    # unmock Time.now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :today=
    end
    
    assert_equal t.amount, drank
  end
  
  test "should return 0 if no drinks have occurred today" do
    adam = Person.find_or_create_by_name('Adam')
    assert_equal 0, adam.drank
  end
end
