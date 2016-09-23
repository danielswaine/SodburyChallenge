Rails.application.routes.draw do

  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'rules' => 'static_pages#rules'
  get 'archive' => 'static_pages#archive'
  get 'results' => 'static_pages#results', as: 'results'
  get 'time' => 'official_time#index'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :challenges, only: [:index, :show, :new, :create, :update, :destroy]

  resources :checkpoints, param: :number,
                          only: [:index, :new, :create, :edit, :update, :destroy]

  resources :goals, only: [:new, :create, :edit, :update, :destroy]

  resources :teams, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :members, only: [:new, :create, :edit, :update, :destroy]
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]

  get 'teams/:id/log' => 'teams#log', as: 'log_team'
  put 'teams/:id/log' => 'teams#update_times'
  patch 'teams/:id/log' => 'teams#update_times'

  get 'teams/:id/score' => 'teams#score', as: 'score_team'
  put 'teams/:id/score' => 'teams#update_score'
  patch 'teams/:id/score' => 'teams#update_score'

  put 'challenges/:id/publish' => 'challenges#publish'
  patch 'challenges/:id/publish' => 'challenges#publish', as: 'publish'

  get 'challenges/:id/statistics' => 'challenges#statistics', as: 'statistics'

  get 'challenges/:id/clipper' => 'challenges#clipper', as: 'clipper'
  
  get 'challenges/:id/master_list' => 'challenges#master_list', as: 'master_list'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
