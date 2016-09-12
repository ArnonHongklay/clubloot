require 'recap/recipes/ruby'
require 'recap/recipes/static'

set :deploy_to, "home/deploy/clubloot"
server 'clubloot.com', :app
set :user, 'deploy'
set :use_sudo, true
set :application, "clubloot"
set :application_user, 'deploy'
set :repository, 'git@github.com:abovelab/clubloot.git'

after 'deploy', 'deploy:reload'

namespace :deploy do
  task :reload, role: :app do
    run "sudo nginx -t"
    run 'sudo service nginx reload'
  end
end
