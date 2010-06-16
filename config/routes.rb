Bumble::Application.routes.draw do |map|

  resources :posts do
    collection do
      get :search
    end
    resources :comments
  end

  resources :comments

  resources :password_resets, :except => [:index, :show, :destroy]

  resources :users

  match 'login',  :to => 'user_sessions#new',     :as => 'login'
  match 'logout', :to => 'user_sessions#destroy', :as => 'logout'
  match 'login',  :to => 'user_sessions#create',  :as => 'login'

  match 'activate/:activation_code', :to => 'users#activate'

  root :to => 'posts#index'

end
