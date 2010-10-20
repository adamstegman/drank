# coding: UTF-8

class DrinksController < ApplicationController
  # GET /drinks
  def index
    # Parse time parameters if given
    begin_time = nil
    end_time = nil
    begin
      if params[:begin]
        begin_time = Time.parse(params[:begin])
      end
      if params[:end]
        end_time = Time.parse(params[:end])
      end
    rescue ArgumentError => ae
      Rails.info "Bad param given: #{ae}"
    end
    
    # Retrieve desired drinks
    if begin_time and end_time
      @drinks = Drink.drank_from(begin_time).drank_to(end_time)
    elsif begin_time
      @drinks = Drink.drank_from(begin_time)
    elsif end_time
      @drinks = Drink.drank_to(end_time)
    else
      # Default to today's drinks
      @drinks = Drink.drank_from(Drink.today)
    end
    @drinks = @drinks.order('created_at ASC')

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /drinks/today
  def today
    redirect_to drinks_path, :begin => Drink.today.to_s
  end
  
  # GET /drinks/this_week
  def this_week
    redirect_to drinks_path, :begin => Drink.this_week.to_s
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
