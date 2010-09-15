# coding: UTF-8

Drank::Application.routes.draw do
  resources :people, :only => [:index] do
    member do
      put :add_drink
    end
  end

  root :to => 'people#index'
end
