Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }, :skip => 'registrations'

  devise_scope :user do
    post 'users' => 'users/registrations#create'
    put 'users/:id/edit' => 'users/registrations#update'
    patch 'users/:id/edit' => 'users/registrations#update', as: :user_registration
    get 'users/cancel' => 'users/registrations#cancel', as: :cancel_user_registration
    get 'users/sign_up' => 'users/registrations#new', as: :new_user_registration
    get 'users/edit' => 'users/registrations#edit', as: :edit_user_registration
    delete 'users' => 'users/registrations#destroy'
  end


  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  root "home#index"
  get '/current_user', to: 'current_user#index'

  resources :users, only: [] do
    resources :posts, only: [:show, :create, :update, :destroy], controller: "user_posts" do
      get '/page/:page', action: :index, on: :collection
    end
  end

  resources :posts, only: [:show] do
    get '/page/:page', action: :index, on: :collection
  end

  resources :categories, only: [:index]

  resources :tags, only: [:index, :create]

end
