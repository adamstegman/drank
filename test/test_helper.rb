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
end
