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
    if cutoff.hour < NEW_DAY_HOUR and cutoff.sunday?
      cutoff = cutoff - 7.days
    end
    # The cutoff is the hour of the day when we consider the day started
    cutoff = Time.new(cutoff.year, cutoff.month, cutoff.day, Drink::NEW_DAY_HOUR, 0, 0)
    
    where("drinks.created_at >= ?", cutoff)
  }
  
  scope :today, lambda {
    now = Time.now
    # Get yesterday's drinks if it's not yet what we consider a new day
    if now.hour < NEW_DAY_HOUR
      now = now - 1.day
    end
    # The cutoff is the hour of the day when we consider the day started
    cutoff = Time.new(now.year, now.month, now.day, Drink::NEW_DAY_HOUR, 0, 0)
    
    where("drinks.created_at >= ?", cutoff)
  }
end
