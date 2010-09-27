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
  scope :today, -> do
    now = Time.now
    # The cutoff is the hour of today when we consider "today" started
    cutoff = Time.new(now.year, now.month, now.day, Drink::NEW_DAY_HOUR, 0, 0)
    # Get yesterday's drinks if it's not yet what we consider a new day
    if now.hour < NEW_DAY_HOUR
      cutoff = Time.new(now.year, now.month, now.day - 1, Drink::NEW_DAY_HOUR, 0, 0)
    end
    
    where("drinks.created_at >= ?", cutoff)
  end
end
