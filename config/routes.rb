Rails.application.routes.draw do
  get '/questions', to: 'questions#index'
  get '/questions/new', to: 'questions#new'

  root 'pages#index'
end
