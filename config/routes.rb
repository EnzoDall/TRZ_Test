Rails.application.routes.draw do
  resources :survivors, only: [:create, :update, :show] do
    member do
      patch 'update_location'
      post 'report_infection'
      post 'trade', to: 'survivors#trade_items'
      post 'report_infection'
    end
  end

  get 'reports/infection_stats', to: 'reports#infection_stats'

end
