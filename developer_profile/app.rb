class DeveloperProfileApp < Sinatra::Base
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  end

  get '/auth/github/callback' do
     auth = request.env['omniauth.auth']
     user = RecruiterExtensions::DeveloperUser.find_or_create_from_auth_hash(auth)
     session[:user_id] = user.id

     redirect '/'
  end

  get '/logout' do
    session[:user_id] = nil

    redirect '/'
  end
end
