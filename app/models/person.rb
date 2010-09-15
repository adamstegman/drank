# coding: UTF-8

class Person < ActiveRecord::Base
  validates_presence_of :name
end
