# coding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Base.class_eval do
    # Returns true if setting +attribute+ to +nil+ generates an error.
    #
    # @param [Symbol] attribute the name of the attribute to test if it is
    #                           required.
    # @return [Boolean] true if +attribute+ is required.
    def requires?(attribute)
      record = self.class.new
      record.send "#{attribute}=", nil
      record.valid?
      record.errors[attribute].any?
    end
  end
  
  # Mock Time.now with the given Time. #unmock_time_now *must* be called in
  # the same test before any dangerous calls are made, e.g. assertions or
  # exceptions, or else the mocked Time.now will persist into other tests.
  #
  # @param [Time] new_now the time to return from Time.now
  def mock_time_now(new_now = Time.now)
    Time.instance_eval do
      def new_now=(new_now)
        @_new_now = new_now
      end
      
      alias :old_now :now
      def now
        @_new_now
      end
    end
    Time.new_now = new_now
  end
  
  # Undo the damage done during #mock_time_now. This must be called before any
  # dangerous calls are made, e.g. assertions or exceptions, or else the
  # mocked Time.now will persist into other tests.
  def unmock_time_now
    Time.instance_eval do
      alias :now :old_now
      undef :old_now
      undef :new_now=
    end
  end
  
  # Returns a local Time instance one second before Drink::NEW_DAY_HOUR.
  # 
  # @return [Time] A Time instance before the new day.
  def time_before_new_day(today = Date.today)
    Time.local(today.year, today.month, today.day, Drink::NEW_DAY_HOUR - 1, 59, 59)
  end
  
  # Returns a local Time instance directly at Drink::NEW_DAY_HOUR.
  # 
  # @return [Time] A Time instance at the crack of a new day.
  def time_at_new_day(today = Date.today)
    Time.local(today.year, today.month, today.day, Drink::NEW_DAY_HOUR, 0, 0)
  end
  
  # == Factories
  def person(name = 'Adam')
    Person.find_or_create_by_name(name)
  end
end
