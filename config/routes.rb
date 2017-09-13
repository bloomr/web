Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: { passwords: 'passwords',
                                    sessions: 'sessions' }

  devise_for :bloomies, controllers: { passwords: 'passwords',
                                       sessions: 'bloomy_sessions' }

  resources :payment, only: [:index, :create]
  get '/payment/thanks', to: 'payment#thanks'
  get '/payment/voucher'
  get '/payment/:program_name', to: 'payment#index', as: 'payment_program'

  get '/me/email_sent', to: 'me#email_sent'
  get '/me/', to: 'me#show'
  get '/me/*other', to: 'me#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static#home'

  resources :tag, only: [:show], param: 'normalized_tag'
  resources :home, only: [:index]
  resources :enrollment, only: [:index, :create], path: 'inscription'

  resources :tribes, only: [:show], path: 'tribus'

  get 'metiers', to: 'jobs#index', as: 'jobs'
  get 'metiers/:normalized_job_title/:normalized_first_name',
      to: 'jobs#show', as: 'job_vanity'

  resources :testimonies, only: [:index], path: 'avis'

  get 'jobs', to: redirect('/metiers')
  get 'tribes', to: redirect('/metiers')
  get 'tribes/:id', to: redirect('tribus/%{id}')
  get 'portraits/:id', to: 'jobs#show_by_id'
  get 'testimonies', to: redirect('/avis')

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

      resources :bloomies, only: [:show]
      resources :programs, only: [:show, :update]
      resources :missions, only: [:create]
    end
  end

  # Static pages
  get 'qui-nous-sommes', to: redirect('/qui-sommes-nous')

  get 'qui-sommes-nous' => 'static#qui_sommes_nous'

  statics = %w( qui-sommes-nous templates
                concept bloomifesto )
  statics.each do |name|
    get name => "static##{name}"
  end

  get 'presse' => 'static#press', as: 'press'
  get 'programme', to: redirect('https://static.bloomr.org'), as: 'program'

  get 'robots.:format', to: 'robots#index'

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

  get 'bouygues/program' => 'static#bouygues'

  get 'sitemap.xml.gz', to: redirect("https://s3-#{ENV['S3_REGION']}.amazonaws.com/#{ENV['S3_BUCKET_NAME']}/sitemaps/sitemap.xml.gz")
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
