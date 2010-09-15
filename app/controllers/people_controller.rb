# coding: UTF-8

class PeopleController < ApplicationController
  NEW_DAY_HOUR = 4
  
  before_filter :reset_drank_if_new_day
  
  # GET /people
  def index
    @people = Person.order('people.name DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @people }
    end
  end
  
  # PUT /people/1/add_drink
  def add_drink
    if params[:oz]
      person = Person.find(params[:id])
      drank = person.drank || 0
      person.drank = drank + params[:oz].to_i
      person.save!
      redirect_to root_path
    else
      redirect_to root_path, :alert => "You need to specify oz drank."
    end
  end
  
  private
  
  # Reset drank counts if this is a new day.
  def reset_drank_if_new_day
    people = Person.all
    return if people.empty?
    if Time.now.hour >= NEW_DAY_HOUR
      last_updated = people.map(&:updated_at).sort.last.getlocal
      if last_updated.hour < NEW_DAY_HOUR or last_updated.day < Time.now.day
        people.each do |person|
          person.drank = 0
          person.save!
        end
      end
    end
  end
end
