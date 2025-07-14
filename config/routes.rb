Rails.application.routes.draw do
  scope "(:locale)", locale: /en|zh-TW/ do
    resources :tasks
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/signup", to: "registrations#new"
    post "/signup", to: "registrations#create"

    get "/admin", to: "admin#index"
    get "/admin/create-user", to: "admin#new"
    post "/admin/create-user", to: "admin#create"
    get "/admin/edit-user/:id", to: "admin#edit", as: "admin_edit_user"
    patch "/admin/edit-user/:id", to: "admin#update"
    delete "/admin/edit-user/:id", to: "admin#destroy"
    # Defines the root path route ("/")
    root "tasks#index"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
