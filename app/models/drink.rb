# coding: UTF-8

# Represents a drink of water with a specified amount. Together, holds the
# history of drinks for this database.
#
# == Attributes
# === Required
# amount:: The number of ounces of water drank.
# == Relationships
# Person:: The Person who made this drink.
class Drink < ActiveRecord::Base
end
