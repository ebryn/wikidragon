# capistrano deploy recipes

set :repository, 'TODO: github repo url'

role :web, "mydomain.com"
role :app, "mydomain.com"
role :db,  "mydomain.com", :primary => true

set :user, "ssh_username"            # defaults to the currently logged in user
set :deploy_to, "/home/ssh_username/mydomain.com"
set :use_sudo, false
set :checkout, "export"
set :svn, "/usr/bin/svn"            # defaults to searching the PATH

namespace :deploy do

  # link to shared db.
  task :before_migrate, :roles => [:web, :app] do
    run "ln -sf #{release_path}/../../database.yml #{release_path}/config/database.yml"
  end

  # TODO dup of above, one can be removed
  task :after_symlink, :roles => [:web, :app] do
    run "ln -sf #{release_path}/../../database.yml #{release_path}/config/database.yml"
  end

  # this works on dreamhost, do what you need to restart on your host here
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

end