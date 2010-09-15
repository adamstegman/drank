# coding: UTF-8

require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  # index tests
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get all people with index" do
    Person.create(:name => "Adam")
    Person.create(:name => "Aubrey")
    get :index
    assert_equal Person.order('people.name DESC'), assigns(:people)
  end
  
  test "should respond with JSON array" do
    Person.create(:name => "Adam", :drank => 1)
    Person.create(:name => "Aubrey", :drank => 2)
    get :index, :format => 'json'
    assert_equal ActiveSupport::JSON.encode(Person.order('people.name DESC')), @response.body
  end
  
  test "should reset drank counts if 4am and last update was before 4am for index" do
    today = Date.today
    Person.create(:name => "Adam", :drank => 1, :updated_at => Time.new(today.year, today.month, today.day, 3, 59, 59))
    Person.create(:name => "Aubrey", :drank => 2, :updated_at => Time.new(today.year, today.month, today.day, 3, 59, 59))
    Time.instance_eval do
      alias :normal_now :now
      def today=(today)
        @today = today
      end
      def now
        Time.new(@today.year, @today.month, @today.day, 4, 0, 0)
      end
    end
    Time.today = today
    get :index
    Person.all.each {|person| assert_equal 0, person.drank}
    Time.instance_eval do
      alias :now :normal_now
      undef :normal_now
      undef :today=
    end
  end
  
  # add_drink tests
  test "should add drink if drank is nil" do
    add = 4
    person = Person.create(:name => "Adam")
    put :add_drink, :id => person, :oz => add.to_s
    assert_equal add, Person.find(person).drank
  end
  
  test "should add drink to existing drank" do
    drank = 1
    add = 3
    person = Person.create(:name => "Adam", :drank => drank)
    put :add_drink, :id => person, :oz => add.to_s
    assert_equal drank + add, Person.find(person).drank
  end
  
  test "should redirect to root after adding drink" do
    person = Person.create(:name => "Adam")
    put :add_drink, :id => person, :oz => '1'
    assert_redirected_to root_path
  end
  
  test "should redirect to root if add drink failed" do
    person = Person.create(:name => "Adam")
    put :add_drink, :id => person
    assert_redirected_to root_path
  end
  
  test "should set flash alert if add drink failed" do
    person = Person.create(:name => "Adam")
    put :add_drink, :id => person
    assert_equal "You need to specify oz drank.", flash[:alert]
  end
  
  test "should reset drank counts if 4am and last update was before 4am for add drink" do
    today = Date.today
    Person.create(:name => "Adam", :drank => 1, :updated_at => Time.new(today.year, today.month, today.day, 3, 59, 59))
    p = Person.create(:name => "Aubrey", :drank => 2, :updated_at => Time.new(today.year, today.month, today.day, 3, 59, 59))
    Time.instance_eval do
      alias :normal_now :now
      def today=(today)
        @today = today
      end
      def now
        Time.new(@today.year, @today.month, @today.day, 4, 0, 0)
      end
    end
    Time.today = today
    put :add_drink, :id => p, :oz => '1'
    Person.all.each do |person|
      if p == person
        assert_equal 1, person.drank
      else
        assert_equal 0, person.drank
      end
    end
    Time.instance_eval do
      alias :now :normal_now
      undef :normal_now
      undef :today=
    end
  end
end
