require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :domain, '52.11.118.225'
set :user, 'ubuntu'
set :deploy_to, '/var/www/dev-hub.io'
set :repository, 'git@github.com:Alliants/developers_index.git'
set :app_path, "#{deploy_to}/#{current_path}"
set :branch, 'master'
set :identity_file, 'deploy.pem'

task :environment do
  invoke :'rbenv:load'
  invoke :'important_variables'
end

task :important_variables => :environment do
  queue! %[source /home/ubuntu/.database]
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

    to :launch do
    end
  end
end

# Unicorn
# ==============================================================================
namespace :unicorn do
  set :unicorn_pid, "/var/dev-io/tmp/pids/unicorn.pid"
  set :start_unicorn, %{
cd #{app_path}
bundle exec unicorn -c #{app_path}/unicorn.rb -E production -D
  }

  # Start task
  # ------------------------------------------------------------------------------
  desc "Start unicorn"
  task :start => :environment do
    queue 'echo "-----> Start Unicorn"'
    queue! start_unicorn
  end

  # Stop task
  # ------------------------------------------------------------------------------
  desc "Stop unicorn"
  task :stop => :environment do
    queue 'echo "-----> Stop Unicorn"'
    queue! %{
test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"`
if [ $? -eq 0 ]; then echo "Stopped"; else echo "Not running"; fi
    }
  end

  # Restart task
  # ------------------------------------------------------------------------------
  desc "Restart unicorn using 'upgrade'"
  task :restart => :environment do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end
