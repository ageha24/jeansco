Rails.application.routes.draw do

  root 'static_pages#home'
  get '/signup',to: 'users#new'
  get '/login',to: 'sessions#new'
  post '/login',to: 'sessions#create'
  get '/auth/:provider/callback',to:'sessions#twitter'
  delete '/logout',to: 'sessions#destroy'
  get 'contact' => 'contact#index'
  post 'contact/confirm' => 'contact#confirm'
  post 'contact/thanks' => 'contact#thanks'
  resources :users
  resources :password_resets, only:[:new,:create,:edit,:update]
  resources :microposts do
    resources :likes, only:[:create,:destroy]
  end
end
