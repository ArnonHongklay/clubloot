set :application, 'clubloot'
set :repo_url,    'git@github.com:abovelab/clubloot.git'

set :deploy_to,   '/home/deploy/clubloot.com'

set :linked_files, %w{config/mongoid.yml config/application.yml}
# set :linked_files, %w{config/application.yml}
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

def red(str)
  "\e[31m#{str}\e[0m"
end

def git_branch(branch)
  puts "Deploying branch #{red branch}"
  branch
end

def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  git_branch branch
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Bower Install'
  task :bower_install do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bower, :install
      end
    end
  end

  before 'deploy:assets:precompile', :bower_install
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

namespace :rails do
  desc 'Console to production'
  task :console do
    on roles(:web) do
      within current_path do
        execute :rails, 'console production'
      end
    end
  end

  desc "Task log"
  task :logs do
    on roles(:web) do
      within current_path do
        execute :tail, '-f log/puma_error.log'
      end
    end
  end
end