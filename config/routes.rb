Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "weathers#show"

  resource :weather, only: :show

  namespace :api do
    namespace :v1 do
      resource :weather, only: :show
    end
  end
end
