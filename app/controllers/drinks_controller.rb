# coding: UTF-8

class DrinksController < ApplicationController
  # GET /drinks
  def index
    # Parse time parameters if given
    @begin_time = nil
    @end_time = nil
    begin
      if params[:begin]
        @begin_time = Time.parse(params[:begin])
      end
      if params[:end]
        @end_time = Time.parse(params[:end])
      end
    rescue ArgumentError => ae
      Rails.info "Bad param given: #{ae}"
    end
    
    # Retrieve desired drinks
    unless @begin_time
      if @end_time
        @begin_time = Drink.first.created_at
      else
        # Default to today's drinks
        @begin_time = Drink.today
      end
    end
    unless @end_time
      @end_time = Time.now
    end
    @drinks = Drink.drank_from(@begin_time).drank_to(@end_time).order('created_at ASC')
    
    # Sum the amounts for each person
    @totals = {}
    @drinks.each do |drink|
      @totals[drink.person_id] ||= {:person => drink.person, :amount => 0}
      @totals[drink.person_id][:amount] += drink.amount
    end
    @totals = @totals.values.sort {|a,b| b[:amount] <=> a[:amount]}

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /drinks/today
  def today
    redirect_to drinks_path(:begin => Drink.today.to_s)
  end
  
  # GET /drinks/this_week
  def this_week
    redirect_to drinks_path(:begin => Drink.this_week.to_s)
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
