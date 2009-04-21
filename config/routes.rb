ActionController::Routing::Routes.draw do |map|
  map.resources :orders

  map.resources :addresses

  map.resource :cart

  map.resources :order_items

  map.resources :carts

  map.resources :news

  map.resources :pages

  map.root :controller => 'pages', :action => 'home'
  map.resources :product_option_vehicle_models

  map.resources :products

  map.home '/home', :controller => 'pages', :action => 'home'
  map.cart '/cart', :controller => 'carts', :action => 'show'
  map.news '/news', :controller => 'news', :action => 'index'
  map.about '/about', :controller => 'pages', :action => 'show', :name => 'about'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session

  map.resources :vehicle_types

  map.resources :product_options

  map.resources :colors

  map.resources :sizes

  map.resources :product_colors

  map.resources :colors

  map.resources :size_groups

  map.resources :color_groups

  map.resources :manufacturers

  map.resources :products

  map.resources :categories

  map.resources :product_images

  map.resources :vehicle_models

  map.resources :vehicle_makes

  map.resources :product_sizes

  map.namespace :manage do |manage|
    manage.root :controller => 'products', :action => 'index'
    manage.resources :colors
    manage.resources :sizes
    manage.resources :color_groups
    manage.resources :size_groups
    manage.resources :product_colors
    manage.resources :product_sizes
    manage.resources :manufacturers
    manage.resources :products
    manage.resources :product_options
    manage.resources :categories
    manage.resources :product_images
    manage.resources :vehicle_models
    manage.resources :vehicle_makes
    manage.resources :vehicle_types
    manage.resources :product_option_vehicle_models
    manage.resources :orders
  end
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
