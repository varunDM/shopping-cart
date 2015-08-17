  Rails.application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root 'home#index'
  
  resources :home
  resources :admin
  resources :company
 
  resources :customer
  post 'customer/:id/bill_address' => 'customer#create_bill_address', as: 'create_bill_address'
  delete 'customer/:id/bill_address/:address_id' => 'customer#remove_bill_address', as: 'remove_bill_address'

  resources :product
  resources :categories

  get 'cart' => 'checkout#view_cart', as: 'view_cart'
  get 'checkout/:product_id' => 'checkout#index', as: 'checkout_index'
  # post 'checkout/cart' => 'checkout#index', as: 'checkout_cart'

  get 'checkout/:product_id/purchase/:bill_address_id' => 'checkout#purchase_show', as: 'purchase_show'

  post 'checkout/:product_id/purchase/:bill_address_id' => 'checkout#purchase_action', as: 'purchase_action'
  get 'checkout/:product_id/success' => 'checkout#success', as: 'purchase_success'

  # product comparison
  get 'compare/:product_id' => 'product#add_to_compare', as: 'product_compare'
  resources :review
  # search-box submission
  post '/search' => 'home#search'

  # add-to cart
  post '/add_to_cart' => 'product#add_to_cart'

  # remove item from mini-cart
  post 'remove_from_cart' => 'product#remove_from_cart'

  # The priority is based upon order of creation
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
