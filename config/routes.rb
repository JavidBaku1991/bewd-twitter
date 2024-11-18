Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  # USERS
  get 'users/:username/tweets', to: 'tweets#index_by_user', as: :user_tweets
  resources :users, only: [:create]

  # SESSIONS
  resources :sessions, only: [:create, :destroy] #
  delete '/sessions', to: 'sessions#destroy' # Add this line
  get '/authenticated', to: 'sessions#authenticated'

  # TWEETS
  resources :tweets, only: [:index] 
  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'



  



  resources :users, only: [:index] do
    get 'tweets', to: 'users#tweets', as: :user_tweets
  end

  resources :tweets do
    collection do
      get 'users/:username', to: 'tweets#index_by_user', as: 'user_tweets'
    end
  end
end
