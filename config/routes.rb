require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"

  resource :cart do
    post 'add_item', to: 'carts#add_item', as: :add_item_to_cart
    delete ':product_id', to: 'carts#remove_item', as: :remove_item
  end

end
