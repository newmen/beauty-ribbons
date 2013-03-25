BeautyRibbons::Application.routes.draw do
  match 'sitemap.xml' => 'sitemap#index', as: 'sitemap', via: :get, defaults: { format: :xml }
  match 'sitemap' => 'sitemap#show', as: 'sitemap_page', via: :get
  match 'products.atom' => 'atom#index', as: 'atom', via: :get, defaults: { format: :atom }

  devise_for :users, controllers: {
    passwords: 'passwords',
    sessions: 'sessions'
  }
  resources :users, except: :show
  resource :current_user, only: [:edit, :update]

  match 'cart' => 'cart#show', as: 'cart', via: :get
  match 'cart/:product_slug' => 'cart#create', as: 'add_to_cart', via: :post, defaults: { format: :js }
  match 'cart/:product_slug' => 'cart#destroy', as: 'remove_from_cart', via: :delete, defaults: { format: :js }

  match 'order/:id/:state' => 'order#update', as: 'update_order_state', via: :put, defaults: { format: :js }
  match 'order/:id' => 'order#destroy', as: 'cancel_order', via: :delete, defaults: { format: :js }
  resources :postal_orders, :pre_orders, except: [:show, :destroy]

  match "control_panel" => 'control_panel#index', as: 'control_panel', via: :get

  Product::STATIC_SCOPES.each do |scope_name|
    match scope_name => 'static_products#index', as: scope_name, via: :get, defaults: { scope_name.to_sym => true }
  end
  match 'delivery' => 'pages#show', as: 'delivery', via: :get, defaults: { identifier: 'delivery' }

  resources :pages, only: [:index, :edit, :update]
  resources :page_images, :product_images, only: [:create, :destroy], defaults: { format: :js }
  resources :badges, :colors, except: :show
  resources :products, only: [:index, :new, :create, :update]
  resources :categories, only: [:index, :new, :create]

  match ':category_slug/products/new' => 'products#new', as: 'new_category_product', via: :get
  match ':category_slug/:slug/edit' => 'products#edit', as: 'edit_category_product', via: :get
  match ':slug/edit' => 'categories#edit', as: 'edit_category', via: :get
  match ':category_slug/:slug' => 'products#show', as: 'category_product', via: :get
  match ':category_slug/:slug' => 'products#destroy', as: 'category_product', via: :delete
  match ':slug' => 'categories#show', as: 'category', via: :get
  match ':slug' => 'categories#update', via: :put
  match ':slug' => 'categories#destroy', via: :delete

  root :to => 'welcome#index'
end
