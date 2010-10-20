# coding: UTF-8

class DrinksController < ApplicationController
  # GET /drinks
  def index
    @drinks = Drink.from_today.order('created_at ASC')

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /drinks/today
  def today
    redirect_to drinks_path
  end
  
  # GET /drinks/this_week
  def this_week
    @drinks = Drink.from_this_week.order('created_at ASC')

    respond_to do |format|
      format.html # this_week.html.erb
    end
  end

  # POST /drinks
  def create
    drink = Drink.new(params[:drink])

    respond_to do |format|
      if drink.save
        format.html { redirect_to root_path }
      else
        format.html { redirect_to root_path, :alert => drink.errors.full_messages.join("; ") }
      end
    end
  end
end
