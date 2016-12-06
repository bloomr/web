Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: { passwords: 'passwords',
                                    sessions: 'sessions' }

  devise_for :bloomies, only: :passwords,
                        controllers: { passwords: 'passwords' }

  resources :payment, only: [:index, :create]
  get '/payment/thanks', to: 'payment#thanks'

  get '/me/email_sent', to: 'me#email_sent'
  get '/me/', to: 'me#show'
  get '/me/*other', to: 'me#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static#home'

  resources :portraits, only: [:show, :aleatoire] do
    get :aleatoire, on: :collection
    get :next, on: :collection
    get :previous, on: :collection
  end

  resources :tag, only: [:show]
  resources :home, only: [:index]
  resources :enrollment, only: [:index, :create]

  resources :tribes, only: [:show]
  get '/tribes', to: redirect('/jobs')

  resources :jobs, only: [:index]
  resources :testimonies, only: [:index]

  namespace :api do
    namespace :v1 do
      get 'me', to: 'me#show'
      post '/me/photo', to: 'me#photo'
      resources :users, only: [:update]
      resources :challenges, only: [:index, :update]
      resources :tribes, only: [:index]
      get '/keywords/top', to: 'keywords#top'
      resources :keywords, only: [:index, :create]
      resources :questions, only: [:update] do
        resources :comments, only: [:index, :create, :destroy]
      end
      resources :books, only: [:create]
      get 'books/search' => 'books#search'
      get 'users/:user_id/books(.:format)' => 'books#get_related_resources',
          relationship: 'books', source: 'api/v1/users'

      get 'users/:user_id/tribes(.:format)' => 'tribes#get_related_resources',
          relationship: 'tribes', source: 'api/v1/users'

      get 'users/:user_id/questions(.:format)' => 'questions#get_related_resources',
          relationship: 'questions', source: 'api/v1/users'

      get 'users/:user_id/challenges(.:format)' => 'challenges#get_related_resources',
          relationship: 'challenges', source: 'api/v1/users'

      get 'users/:user_id/keywords(.:format)' => 'keywords#get_related_resources',
          relationship: 'keywords', source: 'api/v1/users'

      get 'users/:user_id/strengths(.:format)' => 'strengths#get_related_resources',
          relationship: 'strengths', source: 'api/v1/users'

      jsonapi_resources :strengths
    end
  end

  # Static pages
  get 'qui-nous-sommes', to: redirect('/qui-sommes-nous')

  get 'qui-sommes-nous' => 'static#qui_sommes_nous'

  statics = %w( qui-sommes-nous templates
                program press concept bloomifesto )
  statics.each do |name|
    get name => "static##{name}"
  end

  # partner
  get 'partner(/:name)' => 'partner#set_campaign'

  # discourse sso
  get '/sso' => 'discourse_sso#sso'
  post '/sso/login' => 'discourse_sso#login'

  get '/connection' => 'connection#index'

  namespace :admin do
    resources :email_campaigns, only: [:index, :show, :create, :new]
    resources :stats, only: [:index]
  end

  get  'bred/program' => 'bred#index'
  post 'bred/program/create' => 'bred#create'
  get  'bred/program/thanks' => 'bred#thanks'
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
