Rails.application.routes.draw do
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  get "search_category" => "books#search_category"

  devise_for :users

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    get "search" => "users#search"
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
    
  end

  resources :chats, only: [:show, :create]
  resources :groups, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    get "join" => "groups#join"
    delete "leave" => "groups#leave"
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
