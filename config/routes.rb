Rails.application.routes.draw do
  root 'home#top'
  get '/index' => 'schedules#index'
  get '/search' => 'home#search'
  get '/setting' => 'home#setting'

  resources :schedules, except: [:new]
  resources :journals, except: [:new]

  # post '/journals' => 'journals#multicreate'
  # patch '/journals' => 'journals#multiupdate'
  # get '/journals' => 'journals#index'

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
