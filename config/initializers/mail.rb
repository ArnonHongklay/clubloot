Rails.application.config.action_mailer.default_url_options = { host: App.domain }
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.perform_deliveries = false
Rails.application.config.action_mailer.default :charset => "utf-8"
Rails.application.config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'gmail.com',
    user_name:            ENV["GMAIL_USERNAME"],
    password:             ENV["GMAIL_PASSWORD"],
    authentication:       'plain',
    enable_starttls_auto: true
  }

