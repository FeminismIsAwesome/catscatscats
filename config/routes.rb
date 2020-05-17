Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats, only: [:index] do
    collection do
      get :just_cards
    end
  end

  resources :players
  resources :emails, only: :create
  resources :cats_old, only: :index
  resources :cats_games do
    member do
      post :act
      post :start_game
      get :current_state
    end
  end
  resources :cat_cards do
    member do
      post :act
    end
  end
  resources :conversations, only: :index do
    collection do
      get :fuck
    end
  end
  mount ActionCable.server => '/cable'
end
