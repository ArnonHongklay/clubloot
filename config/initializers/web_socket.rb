Rails.application.config.action_cable.url = "ws://#{App.domain}/cable"
Rails.application.config.action_cable.allowed_request_origins = [ App.domain, /http:\/\/example.*/ ]

