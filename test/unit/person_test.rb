# coding: UTF-8

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "should require name" do
    assert Person.new.requires?(:name)
  end
end
