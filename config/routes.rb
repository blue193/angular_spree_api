Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/spree'

  # Custom routes
  Spree::Core::Engine.add_routes do
    namespace :admin, path: Spree.admin_path do

      resources :line_item_option_types do
        collection do
          post :update_positions
          post :update_values_positions
        end
      end

      delete '/line_item_option_values/:id', to: "line_item_option_values#destroy", as: :line_item_option_value
    end

    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :line_item_option_types do
          # resources :line_item_option_values
        end

        # resources :line_item_option_values
        # resources :line_item_option_values, only: :index

        resources :line_item_option_value_detail_record_documents, only: %i(create destroy)

      end
    end

  end
  
  # Main application routes
  scope '/api', module: 'api', defaults: {format: :json} do
    resources :taxonomies, only: :index
    get 'taxons/*permalink', to: 'taxons#show'
    resources :products, only: %i(index show)
    resource :cart do
      post :add_variant
      post :guest_login
      put :update_variant
      put :change_variant
      put :remove_adjustment
      delete :remove_variant
    end
    resource :account
    resources :passwords
    resources :credit_cards, only: :destroy
    resources :addresses, only: :destroy
    resources :countries, only: :index
    resources :orders, only: %i(index show)
  end
end
