Rails.application.routes.draw do
  root 'developers#index'

  get '/lang/:language' => "developers#filter"
  get '/location/:location' => "developers#filter"
  get '/map/:lat/:lng/:language' => "developers#filter", as: "map_filter", :constraints => {:lat => /\-*\d+.\d+/ , :lng => /\-*\d+.\d+/ , :range => /\d+/}
  get '/map_data/:lang' => "developers#map_data", :constraints => {:format => /json/}
  get '/developer/:secure_reference' => "developers#show", as: "developer_profile"
  match "/auth/github/callback" => "developers#create", via: [:get, :post]

  get '/sessions/logout' => "sessions#logout", :constraints => {:format => /json/}
  resources :subscribers, only: [:new, :create]
end
