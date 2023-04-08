Rails.application.routes.draw do
  root to: "top#index"

  resources :uploaded_file, only: [:create]
end
