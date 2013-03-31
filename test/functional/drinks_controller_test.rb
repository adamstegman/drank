# coding: UTF-8

require 'test_helper'

class DrinksControllerTest < ActionController::TestCase
  setup :person, :skip_ensure_domain

  # index tests
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get drinks from today by default for index" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.at_new_day)
    t.save!
    Time.mock_now(Time.at_new_day)

    get :index

    Time.unmock_now

    assert_equal [t], assigns(:drinks)
  end

  test "should accept begin time and unbound end time for index" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.at_new_day)
    t.save!
    Time.mock_now(Time.at_new_day)
    now = Time.now
    begin_time = Time.before_new_day

    get :index, :begin => begin_time.to_s

    Time.unmock_now

    assert_equal [y, t], assigns(:drinks), "should assign correct drinks"
    assert_equal begin_time, assigns(:begin_time), "should assign begin time"
    assert_equal now, assigns(:end_time), "should assign end time"
  end

  test "should accept end time and unbound begin time for index" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.at_new_day)
    t.save!
    Time.mock_now(Time.at_new_day)
    end_time = Time.at_new_day

    get :index, :end => end_time.to_s

    Time.unmock_now

    assert_equal [y, t], assigns(:drinks), "should assign correct drinks"
    assert_equal Drink.first.created_at, assigns(:begin_time), "should assign begin time"
    assert_equal end_time, assigns(:end_time), "should assign end time"
  end

  test "should accept both begin and end times for index" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.at_new_day)
    t.save!
    Time.mock_now(Time.before_new_day)
    begin_time = Time.at_new_day
    end_time = begin_time + 1.second

    get :index, :begin => begin_time.to_s, :end => end_time.to_s

    Time.unmock_now

    assert_equal [t], assigns(:drinks), "should assign correct drinks"
    assert_equal begin_time, assigns(:begin_time), "should assign begin time"
    assert_equal end_time, assigns(:end_time), "should assign end time"
  end

  test "should show no drinks given begin after end for index" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.before_new_day)
    y.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.at_new_day)
    t.save!
    Time.mock_now(Time.at_new_day)
    begin_time = Time.at_new_day
    end_time = Time.before_new_day

    get :index, :begin => begin_time.to_s, :end => end_time.to_s

    Time.unmock_now

    assert_equal [], assigns(:drinks), "should assign correct drinks"
    assert_equal begin_time, assigns(:begin_time), "should assign begin time"
    assert_equal end_time, assigns(:end_time), "should assign end time"
  end

  test "should get drinks sorted by created at ascending" do
    y = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.before_new_day)
    y.save!
    t2 = Drink.new(:amount => 1, :person_id => person.id,
                   :created_at => Time.at_new_day + 1.second)
    t2.save!
    t = Drink.new(:amount => 1, :person_id => person.id,
                  :created_at => Time.at_new_day)
    t.save!
    Time.mock_now(Time.at_new_day + 1.second)

    get :index

    Time.unmock_now

    assert_equal [t, t2], assigns(:drinks)
  end

  test "should sum the drinks for each person in the time period" do
    adam = person('Adam')
    aubrey = person('Aubrey')
    adam_amount = 0
    aubrey_amount = 0
    adam_amount += drink(:person => adam, :created_at => Time.at_new_day).amount
    aubrey_amount += drink(:person => aubrey, :created_at => Time.at_new_day).amount
    aubrey_amount += drink(:person => aubrey, :created_at => Time.at_new_day + 1.second).amount
    Time.mock_now(Time.at_new_day + 1.second)

    get :index

    Time.unmock_now

    assert_equal [{'person' => aubrey, 'amount' => aubrey_amount},
                  {'person' => adam, 'amount' => adam_amount}],
                 assigns(:totals)
  end

  # create tests
  test "should create drink" do
    assert_difference('Drink.count') do
      post :create, :drink => {:person_id => person.to_param, :amount => "1"}
    end
  end

  test "should redirect to root after creating drink" do
    post :create, :drink => {:person_id => person.to_param, :amount => "1"}
    assert_redirected_to root_path
  end

  private

  def skip_ensure_domain
    ApplicationController.class_eval do
      skip_before_filter :ensure_domain
    end
  end
end
