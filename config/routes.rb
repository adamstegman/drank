Drank::Application.routes.draw do
  resources :people, :only => [:index] do
    member do
      put :add_drink, :reset_drank
    end
  end

  root :to => 'people#index'
end
