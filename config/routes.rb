Rails.application.routes.draw do
  root to: "top#index"

  resources :uploaded_file, only: [:create, :edit, :update] do
    member do
      get :download
      post :prepare_workdocs
      get :show_workdocs_link
    end
  end
end
