# coding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # ActiveRecord instance test helpers
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

  # Time class test helpers
  Time.instance_eval do
    # Returns a local Time instance directly at Drink::NEW_DAY_HOUR.
    #
    # @return [Time] A Time instance at the crack of a new day.
    def at_new_day(date = Date.today)
      self.local(date.year, date.month, date.day, Drink::NEW_DAY_HOUR, 0, 0)
    end

    # Returns a local Time instance one second before Drink::NEW_DAY_HOUR.
    #
    # @return [Time] A Time instance before the new day.
    def before_new_day(date = Date.today)
      self.local(date.year, date.month, date.day, Drink::NEW_DAY_HOUR - 1, 59, 59)
    end

    # Mock Time.now with the given Time. Time.unmock_now *must* be called in
    # the same test before any dangerous calls are made, e.g. assertions or
    # exceptions, or else the mocked Time.now will persist into other tests.
    #
    # @param [Time] new_now the time to return from Time.now
    def mock_now(new_now = self.now)
      self.instance_eval do
        @_new_now = new_now
        alias :old_now :now
        def now
          @_new_now
        end
      end
    end

    # Undo the damage done during Time.mock_now. This must be called before
    # any dangerous calls are made, e.g. assertions or exceptions, or else the
    # mocked Time.now will persist into other tests.
    def unmock_now
      self.instance_eval do
        @_new_now = nil
        alias :now :old_now
        undef :old_now
      end
    end
  end

  # == Factories
  def drink(attributes = {})
    unless attributes[:person] or attributes[:person_id]
      attributes[:person] = person
    end
    attributes[:amount] ||= 1
    Drink.create(attributes)
  end

  def person(name = 'Adam')
    Person.find_or_create_by_name(name)
  end
end
