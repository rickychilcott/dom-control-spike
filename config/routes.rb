Rails.application.routes.draw do
  post "clear_cache" => "tasks#clear_cache"
  resources :resources, except: [:show]
  root "resources#index"
end
