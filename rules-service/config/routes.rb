Rails.application.routes.draw do
  scope '/rules' do
    get "up" => "rails/health#show", as: :rails_health_check

    resources :rules
  end
end
