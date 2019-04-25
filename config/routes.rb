Rails.application.routes.draw do
  get "posts/:id/:start_time/edit" => "posts#edit"
  get "posts/:start_time/new" => "post#new"
  get "posts/admin" => "posts#admin"
  post "posts/admin" => "posts#create"
  resources :posts
  get '/' => "home#top"
  get "about" => "home#about"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
