# coding: UTF-8

Drank::Application.routes.draw do
  resources :people, :only => [:index]
  resources :drinks, :only => [:index, :create] do
    collection do
      get 'today'
      get 'this_week'
    end
  end

  root :to => 'people#index'
end
