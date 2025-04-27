Rails.application.routes.draw do
  scope '/alerts' do
    get "up" => "rails/health#show", as: :rails_health_check

    resources :alerts, only: [] do
      collection do
        get :active
        get :history
      end

      member do
        post :acknowledge
        post :snooze
      end
    end
  end
end
