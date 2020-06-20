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
      get :refresh_state
      post :simulate_cat_round
      post :simulate_card_playing_round
    end
  end
  resources :cat_cards do
    member do
      post :pick
      post :burn
      post :play
      post :play_choice
    end
    collection do
      post :pass
    end
  end
  resources :conversations, only: :index do
    collection do
      get :fuck
    end
  end

  resources :shelter_cats do
    collection do
      post :bid
    end
  end

  mount ActionCable.server => '/cable'
end
