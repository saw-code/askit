# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session, only: %i[new create destroy] # 108

  resources :users, only: %i[new create edit update] # 112 edit, update

  resources :questions do
    resources :answers, except: %i[new show]
  end

  namespace :admin do
    resources :users, only: %i[index create]
  end

  root 'pages#index'
end
