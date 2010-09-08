Drank::Application.routes.draw do
  resources :people, :only => [:index]

  root :to => 'people#index'
end
