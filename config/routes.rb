Rails.application.routes.draw do
  post "clear_cache" => "tasks#clear_cache"
  post "generate_models" => "tasks#generate_models"

  resources :resources, except: [:show]
  root "resources#index"
end
