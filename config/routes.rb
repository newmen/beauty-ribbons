BeautyRibbons::Application.routes.draw do
  get "sitemap.xml" => "sitemap#index", as: "sitemap", defaults: { format: :xml }
  get "sitemap" => "sitemap#show", as: "sitemap_page"
  get "products.atom" => "atom#index", as: "atom", defaults: { format: :atom }

  devise_for :users, controllers: {
    passwords: "passwords",
    sessions: "sessions"
  }
  resources :users, except: :show
  resource :current_user, only: [:edit, :update]

  get "cart" => "cart#show", as: "cart"
  post "cart/:product_slug" => "cart#create", as: "add_to_cart", defaults: { format: :js }
  delete "cart/:product_slug" => "cart#destroy", as: "remove_from_cart", defaults: { format: :js }

  put "order/:id/:state" => "order#update", as: "update_order_state", defaults: { format: :js }
  delete "order/:id" => "order#destroy", as: "cancel_order", defaults: { format: :js }
  resources :postal_orders, :pre_orders, except: [:show, :destroy]

  get "control_panel" => "control_panel#index", as: "control_panel"

  Product::STATIC_SCOPES.each do |scope_name|
    get scope_name => "static_products#index", as: scope_name, defaults: { scope_name.to_sym => true }
  end
  get "delivery" => "pages#show", as: "delivery", defaults: { identifier: "delivery" }

  resources :pages, only: [:index, :edit, :update]
  resources :page_images, :product_images, only: [:create, :destroy], defaults: { format: :js }
  resources :badges, :colors, except: :show
  resources :products, only: [:index, :new, :create, :update]
  resources :categories, only: [:index, :new, :create]

  get ":category_slug/products/new" => "products#new", as: "new_category_product"
  get ":category_slug/:slug/edit" => "products#edit", as: "edit_category_product"
  get ":slug/edit" => "categories#edit", as: "edit_category"
  get ":category_slug/:slug" => "products#show", as: "category_product"
  delete ":category_slug/:slug" => "products#destroy"
  get ":slug" => "categories#show", as: "category"
  put ":slug" => "categories#update"
  delete ":slug" => "categories#destroy"

  root to: "welcome#index"
end
