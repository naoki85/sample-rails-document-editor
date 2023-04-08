Rails.application.routes.draw do
  root to: "top#index"

  resources :uploaded_file, only: [:create, :edit, :update] do
    member do
      get :download
    end
  end
end
