# coding: UTF-8

# A Person who drinks Drinks.
# == Attributes
# === Required
# name:: the Person's name.
# == Relationships
# Drink:: has_many - the drink history of this Person.
class Person < ActiveRecord::Base
  # == Relationships
  has_many :drinks
  
  # == Validations
  validates_presence_of :name
  
  # == Instance Methods
  
  # Returns the amount of water this Person has drank today, or 0 if no Drinks
  # are recorded for today.
  #
  # @return [Integer] The sum of the Drink amounts for today.
  def drank
    self.drinks.today.map(&:amount).inject(:+) || 0
  end
end
