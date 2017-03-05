require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.config.active_job.queue_adapter = :sidekiq

Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["admin", "sushimasa"]
end

Sidekiq.configure_server do |config|
  schedule_file = "#{Rails.root}/config/scheduler.yml"

  if File.exists?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
  end
  # config.on(:startup) do
  #   Sidekiq.schedule = YAML.load_file(File.expand_path("#{Rails.root}/config/scheduler.yml", __FILE__))
  #   Sidekiq::Scheduler.reload_schedule!
  # end
end
