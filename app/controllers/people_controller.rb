class PeopleController < ApplicationController
  # GET /people
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
