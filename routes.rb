Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'
  put 'password/update', to: 'password#update'
  resources :users, only: [:create, :update] do
    collection do
        post 'email_update'
end