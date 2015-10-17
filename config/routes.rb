Rails.application.routes.draw do
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV["SIDEKIQ_USR"] && password == ENV["SIDEKIQ_PASS"]
  end if Rails.env.production?

  mount Sidekiq::Web => '/admin/sidekiq'

  root 'developers#search'

  get '/example' => "developers#example"
  get '/search' => "developers#search"

  get '/lang/:language' => "developers#filter"
  get '/location/:location' => "developers#filter"
  get '/map/:lat/:lng/:language' => "developers#filter", as: "map_filter", :constraints => {:lat => /\-*\d+.\d+/ , :lng => /\-*\d+.\d+/ , :range => /\d+/}

  get '/developer/:secure_reference' => "developers#show", as: "developer_profile"
  get '/developer/:secure_reference/update_data' => "developers#update_data"
  put '/developer/:secure_reference/toggle_public' => "developers#toggle_public", as: "developer_public"
  put '/developer/:secure_reference/watch' => "developers#watch", as: "developer_watch"

  match '/add_github_developer' => "developers#create_profile", as: "create_github_dev_profile", via: [:get, :post]

  get '/recruiter/:id' => "recruiters#show", as: "recruiter_profile"
  get '/recruiter/:id/following' => "recruiters#following", as: "recruiter_developers"

  match "/auth/github/callback" => "developers#create", via: [:get, :post]
  match "/auth/linkedin/callback" => "recruiters#create", via: [:get, :post]

  get '/about' => "information#about"

  get '/sessions/logout' => "sessions#logout", :constraints => {:format => /json/}
  resources :subscribers, only: [:new, :create]
end
