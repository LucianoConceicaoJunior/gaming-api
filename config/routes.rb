# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  namespace :api do
    get 'up' => 'rails/health#show', as: :rails_health_check
    namespace :management do
       resource :organization, as: :organization do
         resources :projects, only: [ :index ] do
           resources :leaderboards, only: [ :index ]
         end
       end
    end
    namespace :gaming do
      api_guard_scope 'users' do
        post 'sign_in', controller: 'users/authentication', action: :create
        delete 'sign_out', controller: 'users/authentication', action: :destroy
        post 'refresh_access_token', controller: 'users/tokens', action: :create
      end
      post 'insert_leaderboard_row', controller: :leaderboard_rows, action: :create
      get 'get_leaderboard_rank', controller: :leaderboard_rows, action: :get_leaderboard_rank
      get 'get_user_rank', controller: :leaderboard_rows, action: :get_user_rank
    end
  end
end
