class PeopleController < ApplicationController
  # GET /people
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @people }
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
  
  # PUT /people/1/reset_drank
  def reset_drank
    person = Person.find(params[:id])
    person.drank = 0
    person.save!
    redirect_to root_path
  end
end
