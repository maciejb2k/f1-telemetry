Rails.application.routes.draw do
  scope '/alerts' do
    get "up" => "rails/health#show", as: :rails_health_check

    resources :alerts, only: [:index, :show]
  end
end
