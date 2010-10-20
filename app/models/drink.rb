# coding: UTF-8

# Represents a drink of water with a specified amount. Together, holds the
# history of drinks for this database.
#
# == Attributes
# === Required
# amount:: The number of ounces of water drank.
# == Relationships
# Person:: belongs_to - The Person who made this drink.
class Drink < ActiveRecord::Base
  # == Constants
  NEW_DAY_HOUR = 4
  
  # == Relationships
  belongs_to :person
  
  # == Validations
  validates_presence_of :amount, :person
  
  # == Class Methods
  scope :drank_from, lambda {|from| where('created_at >= ?', from)}
  scope :drank_to, lambda {|to| where('created_at <= ?', to)}
  
  class << self
    # Returns a Time instance representing the last occurrence of
    # NEW_DAY_HOUR.
    #
    # @return [Time] The last occurrence of NEW_DAY_HOUR.
    def today
      now = Time.now
      # Get yesterday's drinks if it's not yet what we consider a new day
      if now.hour < NEW_DAY_HOUR
        now = now - 1.day
      end
      Time.local(now.year, now.month, now.day, NEW_DAY_HOUR, 0, 0)
    end
    
    # Returns a Time instance representing the last occurrence of
    # NEW_DAY_HOUR on a Sunday.
    #
    # @return [Time] The last occurrence of NEW_DAY_HOUR.
    def this_week
      now = Time.now
      new_week = now - now.wday.days
      # Get last week's drinks if it's not yet what we consider a new week
      if now.wday == 0 and now.hour < NEW_DAY_HOUR
        new_week = new_week - 7.days
      end
      Time.local(new_week.year, new_week.month, new_week.day, NEW_DAY_HOUR, 0, 0)
    end
  end
end
