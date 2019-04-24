Rails.application.routes.draw do
  get "posts/:start_time/new" => "posts#new"
  resources :posts
  get '/' => "home#top"
  get "about" => "home#about"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
