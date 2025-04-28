Rails.application.routes.draw do
  scope '/telemetry' do
    get "up" => "rails/health#show", as: :rails_health_check

    resources :cars, param: :code do
      resources :readings do
        collection do
          get :latest
        end
      end
    end
  end
end
