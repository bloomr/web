Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: { passwords: 'passwords' }

  resources :payment, only: [:index, :create]
  get '/payment/thanks', to: 'payment#thanks'

  get '/me', to: 'me#show'
  patch '/me', to: 'me#update'
  put '/me', to: 'me#update'
  get '/me/email_sent', to: 'me#email_sent'
  post '/me/challenge1', to: 'me#challenge_1'

  get '/me2', to: redirect('/me2/whatsnew')
  get '/me2/*other', to: 'me2#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :portraits, only: [:show, :aleatoire] do
    get :aleatoire, on: :collection
    get :next, on: :collection
    get :previous, on: :collection
  end

  resources :tag, only: [:show]
  resources :home, only: [:index]
  resources :enrollment, only: [:index, :create]
  get '/enrollment/thanks', to: 'enrollment#thanks'

  resources :tribes, only: [:index, :show]

  namespace :api do
    namespace :v1 do
      resources :users, only: [:update, :show]
      resources :tribes, only: [:index]
      resources :keywords, only: [:index]
      resources :questions, only: [:update] do
        resources :comments, only: [:index, :create, :destroy]
      end
      resources :books, only: [:create]
      get 'books/search' => 'books#search'
      get 'users/:user_id/books(.:format)' => 'books#get_related_resources',
          relationship: 'books', source: 'api/v1/users'
    end
  end

  # Static pages (Strikingly content)
  get 'le-concept' => 'static#le_concept'
  get 'qui-nous-sommes', to: redirect('/qui-sommes-nous')
  get 'qui-sommes-nous' => 'static#qui_sommes_nous'
  get 'le-parcours' => 'static#le_parcours'
  get 'templates' => 'static#templates'

  # partner
  get 'partner(/:name)' => 'partner#set_campaign'

  # discourse sso
  get '/sso' => 'discourse_sso#sso'
  post '/sso/login' => 'discourse_sso#login'

  get '/connection' => 'connection#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
