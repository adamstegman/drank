# coding: UTF-8

Drank::Application.routes.draw do
  resources :people, :only => [:index] do
    member do
      put :add_drink
    end
  end
  resources :drinks, :only => [:index, :new, :create]

  root :to => 'people#index'
end
