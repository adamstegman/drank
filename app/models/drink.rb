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
  scope :this_week, lambda {
    now = Time.now
    cutoff = now - now.wday.days
    # Get last week's drinks if it's not yet what we consider a new week
    if now.wday == 0 and now.hour < new_day_hour
      cutoff = cutoff - 7.days
    end
    # The cutoff is the hour of the day when we consider the day started
    cutoff = Time.gm(cutoff.year, cutoff.month, cutoff.day, new_day_hour, 0, 0)
    
    where("drinks.created_at >= ?", cutoff)
  }
  
  scope :today, lambda {
    now = Time.now
    # Get yesterday's drinks if it's not yet what we consider a new day
    if now.hour < new_day_hour
      now = now - 1.day
    end
    # The cutoff is the hour of the day when we consider the day started
    cutoff = Time.gm(now.year, now.month, now.day, new_day_hour, 0, 0)
    
    where("drinks.created_at >= ?", cutoff)
  }
  
  class << self
    # Returns the hour of the day that is considered a "new day".
    def new_day_hour
      if Time.now.dst?
        (NEW_DAY_HOUR + 5) % 24
      else
        (NEW_DAY_HOUR + 6) % 24
      end
    end
  end
end
