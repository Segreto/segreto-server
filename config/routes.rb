SegretoServer::Application.routes.draw do
  constraints format: 'json' do
    get    'user'         => 'user#show',    as: :user
    post   'user'         => 'user#create',  as: :user_create
    get    'user/signin'  => 'user#signin',  as: :user_signin
    get    'user/signout' => 'user#signout', as: :user_signout
    patch  'user/update'  => 'user#update',  as: :user_update
    put    'user/update'  => 'user#update'
    delete 'user'         => 'user#destroy', as: :user_delete

    get    'secrets'      => 'secret#index',   as: :secrets
    post   'secret'       => 'secret#create',  as: :secret_create
    get    'secret/:key'  => 'secret#show',    as: :secret
    patch  'secret/:key'  => 'secret#update',  as: :secret_update
    put    'secret/:key'  => 'secret#update'
    delete 'secret/:key'  => 'secret#destroy', as: :secret_delete
  end

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
