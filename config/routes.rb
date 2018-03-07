Rails.application.routes.draw do
  root 'home#top'
  get '/index' => 'schedules#index'
  get '/search' => 'home#search'
  get '/setting' => 'home#setting'

  resources :schedules, except: [:new] do
    collection do
      get 'autocomplete_place_name'
      get 'autocomplete_program'
      get 'autocomplete_performer'
      get 'autocomplete_seat_type'
      get 'autocomplete_otherside_name'
    end
  end
  resources :journals, except: [:new]
  resources :othersides, except:[:new]
  resources :events,except: [:new]
  resources :trade_account_dicts

  resource :settings, only: [:index] do
    resources :users, only:[:index]
  end

  devise_for :users,:controllers => {
 :registrations => 'users/registrations'
}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
