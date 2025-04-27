Rails.application.routes.draw do
  scope '/telemetry' do
    get "up" => "rails/health#show", as: :rails_health_check

    resources :cars, only: [:index]
    post 'cars/:car_code/readings', to: 'readings#create'
    get 'cars/:car_code/readings/latest', to: 'readings#latest'
  end
end
