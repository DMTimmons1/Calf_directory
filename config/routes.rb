Rails.application.routes.draw do
  root "calves#index"

  resources :calves do
    post "medication", to: "calf_events#medication"
  end
end