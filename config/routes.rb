Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks:  "users/omniauth_callbacks"
  }

  devise_scope :user do
    ## ↓登録方法の選択ページ
    get "users/select_registration", to: 'users/registrations#select', as: :select_registration
  end

  root to: "items#index"

  resource :users, only: [:show] do
    collection do
      get "card"
      get "selling"
      get "selling_progress"
      get "sold"
      get "bought_progress"
      get "bought_past"
    end
  end

  resources :items  do
    member do
      get "purchase_confirmation"
      post "purchase"
    end
  end
  resources :categories, only: [:index, :show]
  resource :cards, only: [:new, :create, :show, :update, :destroy]

end
