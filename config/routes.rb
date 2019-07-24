Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users, except: :index, format: "json"
      post 'users/authenticate', to: 'authentication#authenticate',
                                 as: 'user_authenticate', format: "json"
      get 'user/me', to: 'users#show_me', as: 'users_me', format: "json"
    end
  end
end
