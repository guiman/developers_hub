Rails.application.routes.draw do
  root 'information#welcome'

  get '/example' => "developers#example"
  get '/search' => "developers#search"

  get '/lang/:language' => "developers#filter"
  get '/location/:location' => "developers#filter"
  get '/location/:location/lang/:language' => "developers#filter"
  get '/map/:lat/:lng/:language' => "developers#filter", as: "map_filter", :constraints => {:lat => /\-*\d+.\d+/ , :lng => /\-*\d+.\d+/ , :range => /\d+/}

  get '/developer/:secure_reference' => "developers#show", as: "developer_profile"
  post '/developer/:secure_reference/contact' => "developers#contact", as: "developer_contact"
  put '/developer/:secure_reference/toggle_public' => "developers#toggle_public", as: "developer_public"

  get '/recruiter/:id' => "recruiters#show", as: "recruiter_profile"

  match "/auth/github/callback" => "developers#create", via: [:get, :post]
  match "/auth/linkedin/callback" => "recruiters#create", via: [:get, :post]

  get '/about' => "information#about"

  get '/sessions/logout' => "sessions#logout", :constraints => {:format => /json/}
  resources :subscribers, only: [:new, :create]
end
