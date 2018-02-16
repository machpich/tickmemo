Rails.application.routes.draw do
  root 'home#top'
  get '/index' => 'schedules#index'
  get '/search' => 'home#search'

  resources :schedules, only: [:index,:show,:create,:update,:destroy]
  resources :journals, only: [:index,:create,:update,:destroy]
  resources :othersides, except:[:index,:new]
  resources :events,except: [:index,:new]

  get '/setting' => 'home#setting'
  resource :settings, only: [:index] do
    resources :users, only:[:index]
  end

  devise_for :users,:controllers => {
 :registrations => 'users/registrations'
}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
