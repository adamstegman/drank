# coding: UTF-8

Drank::Application.routes.draw do
  resources :people, :only => [:index]
  resources :drinks, :only => [:index, :create]

  root :to => 'people#index'
end
