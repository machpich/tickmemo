Rails.application.routes.draw do
  root 'home#top'
  get '/index' => 'schedules#index'
  get '/search' => 'home#search'
  get '/setting' => 'home#setting'
  get '/etc' => 'home#etc'

  resources :schedules, except: [:new] do
    collection do
      get 'autocomplete_place_name'
      get 'autocomplete_program'
      get 'autocomplete_performer'
      get 'autocomplete_seat_type'
      get 'autocomplete_otherside_name'
      get 'result'
    end
    member do
      delete 'destroy_from_scheule'
      get 'copy'
    end
  end
  resources :journals, except: [:new]
  resources :othersides, except:[:new]
  resources :events
  resources :trade_account_dicts, only:[:index,:create,:destroy]
  resources :trade_types, only:[:destroy]

  resource :settings, only: [:index] do
    resources :users, only:[:index]
  end

  devise_for :users,:controllers => {
 :registrations => 'users/registrations'
}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
