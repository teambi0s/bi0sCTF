Rails.application.routes.draw do
  root 'home#index'
  get 'health', to: 'healthcheck#index'
  get 'register', to: 'register#register', as: :register
  get 'validate', to: 'validate#index'
  post 'register', to: 'register#register'
  get 'settings', to: 'settings#settings', as: :settings
  post 'settings', to: 'settings#settings'
  get 'legacy', to: 'legacy#index', as: :legacy
  post 'legacy', to: 'legacy#index'
  get ':username', to: 'profile#show', constraints: { username: /[^\/]+/ }
end