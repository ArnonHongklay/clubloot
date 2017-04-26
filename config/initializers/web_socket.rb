Rails.application.config.action_cable.url = "ws://api.#{App.root_domain}/cable"
Rails.application.config.action_cable.allowed_request_origins = [ App.domain, App.domain('admin'), App.domain('api'), 'alpha.clubloot.com', 'staging.clubloot.com' ]
Rails.application.config.action_cable.disable_request_forgery_protection = false
