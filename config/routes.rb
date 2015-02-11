Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :locations do
    resources :locations, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :locations, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :locations, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
