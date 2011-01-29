set :user,          "wowcrafter"
set :domain,        "wowcrafter.kapowaz.net"
set :repository,    "ssh://git@github.com/kapowaz/wowcrafter.git"
set :use_sudo,      false
set :scm,           "git"
set :branch,        "master"
set :stages,        %w(staging production)
set :default_stage, "staging"

role :app,        domain
role :web,        domain
role :db,         domain

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :gems do
  desc "Updates bundled gems as necessary"
  task :bundle do
    run "cd #{current_path}; bundle install --deployment"
  end
end

after "deploy:update", "gems:bundle"

require 'capistrano/ext/multistage'