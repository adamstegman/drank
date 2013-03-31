# coding: UTF-8

require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup :skip_ensure_domain

  # index tests
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get all people with index" do
    person('Adam')
    person('Aubrey')
    get :index
    assert_equal Person.order('people.name DESC'), assigns(:people)
  end

  test "should respond with JSON array" do
    person('Adam')
    person('Aubrey')
    get :index, :format => 'json'
    assert_equal Person.order('people.name DESC').to_json(:methods => :drank), @response.body
  end

  private

  def skip_ensure_domain
    ApplicationController.class_eval do
      skip_before_filter :ensure_domain
    end
  end
end
