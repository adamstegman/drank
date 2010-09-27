# coding: UTF-8

require 'test_helper'

class DrinkTest < ActiveSupport::TestCase
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
    Person.find_or_create_by_name('Adam')
    today = Date.today
    today = today - today.wday.days
    
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
    
    y = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR - 1, 59, 59))
    y.save!
    t = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR, 0, 0))
    t.save!
    
    this_weeks_drinks = Drink.this_week
    
    # unmock Time.now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :today=
    end
    
    assert_equal [t], this_weeks_drinks
  end
  
  test "should return drinks from last week if now is before new day hour" do
    Person.find_or_create_by_name('Adam')
    today = Date.today
    today = today - today.wday.days
    
    # mock Time.now
    Time.instance_eval do
      def today=(today)
        @today = today
      end
      
      alias :old_now :now
      def now
        Time.gm(@today.year, @today.month, @today.day, Drink::NEW_DAY_HOUR - 1, 59, 59)
      end
    end
    Time.today = today
    
    today = today - 7.days
    y = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR - 1, 59, 59))
    y.save!
    t = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR, 0, 0))
    t.save!
    
    this_weeks_drinks = Drink.this_week
    
    # unmock Time.now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :today=
    end
    
    assert_equal [t], this_weeks_drinks
  end
  
  # today scope tests
  test "should return drinks from today if now is on or after new day hour" do
    Person.find_or_create_by_name('Adam')
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
    
    y = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR - 1, 59, 59))
    y.save!
    t = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR, 0, 0))
    t.save!
    
    todays_drinks = Drink.today
    
    # unmock Time.now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :today=
    end
    
    assert_equal [t], todays_drinks
  end
  
  test "should return drinks from yesterday if now is before new day hour" do
    Person.find_or_create_by_name('Adam')
    today = Date.today
    
    # mock Time.now
    Time.instance_eval do
      def today=(today)
        @today = today
      end
      
      alias :old_now :now
      def now
        Time.gm(@today.year, @today.month, @today.day, Drink::NEW_DAY_HOUR - 1, 59, 59)
      end
    end
    Time.today = today
    
    today = today - 1.day
    y = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR - 1, 59, 59))
    y.save!
    t = Drink.new(:amount => 1, :person_id => Person.first.id,
                  :created_at => Time.gm(today.year, today.month, today.day, Drink::NEW_DAY_HOUR, 0, 0))
    t.save!

    todays_drinks = Drink.today
    
    # unmock Time.now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :today=
    end
    
    assert_equal [t], todays_drinks
  end
end
