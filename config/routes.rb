Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  

  get "/songs/download.:format", to: "songs#download"
  get "/mysongs", to: "songs#mysongs"
  resources :songs do
    member do
      put :remove_tag
    end
  end
  resources :tags do
    resources  :songs
  end



end
