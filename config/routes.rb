SegretoServer::Application.routes.draw do
  constraints format: 'json' do
    get    'user'         => 'user#show',    as: :user
    post   'user'         => 'user#create',  as: :user_create
    post   'user/signin'  => 'user#signin',  as: :user_signin
    post   'user/signout' => 'user#signout', as: :user_signout
    patch  'user/update'  => 'user#update',  as: :user_update
    put    'user/update'  => 'user#update'
    delete 'user'         => 'user#destroy', as: :user_delete
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
