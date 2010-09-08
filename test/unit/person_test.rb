require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "should require name" do
    person = Person.new
    person.name = nil
    person.valid?
    assert person.errors[:name].any?
  end
end
