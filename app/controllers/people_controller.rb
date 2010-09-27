# coding: UTF-8

class PeopleController < ApplicationController
  # GET /people
  def index
    @people = Person.order('people.name DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @people.to_json(:methods => :drank) }
    end
  end
end
