Rails.application.routes.draw do
require 'sidekiq/web'

  #root_url
  root 'home#index'
  
  #sidekiq GUI dashboard
  mount Sidekiq::Web => "/sidekiq"

  get 'appointments/recent'

  resources :appointments

  #Overwridden devise default user controllers
  devise_for :users , controllers: {registrations: "registrations", omniauth_callbacks: "omniauth_callbacks", sessions: "sessions"} 

  resources :users do 
      resources :notes
  end  

  resources :appointments do 
    resources :notes 
  end


  get "appointments" => "appointments#index"

  #show all recebt Appointments of user
  

  #show user profile
  get  "home/profile"

  #shows the available slots of a doctor on a give date
  post "appointments/slots" => "appointments#get_available_slots"

  #edit user profile
  get  "home/edit"

  #change profile picture
  post "home/profile" => "home#change_profile_pciture"

  #handling other urls
  get '*path'   => 'home#error404'

  

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
