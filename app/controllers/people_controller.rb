class PeopleController < ApplicationController
  # GET /people
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # PUT /people/1/add_drink
  def add_drink
    person = Person.find(params[:id])
    drank = person.drank || 0
    person.drank = drank + 1
    person.save!
    redirect_to root_path
  end
end
