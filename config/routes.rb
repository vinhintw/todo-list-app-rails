Rails.application.routes.draw do
  get "home/index"
  resources :tasks do
    collection do
      get :all
      get :pending
      get :in_progress
      get :completed
      get :cancelled
      get :low_priority
      get :medium_priority
      get :high_priority
      get :urgent_priority
    end
  end
  resource :session, only: [ :new, :create, :destroy ]
  resource :registration, only: [ :new, :create ]

  # Admin routes
  get "admin", to: "admin#index"
  delete "admin/users/:id", to: "admin#destroy_user", as: "admin_destroy_user"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
