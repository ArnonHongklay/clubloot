Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  def add_swagger_route http_method, path, opts = {}
    full_path = path.gsub(/{(.*?)}/, ':\1')
    match full_path, to: "#{opts.fetch(:controller_name)}##{opts[:action_name]}", via: http_method
  end

  # add_swagger_route 'GET', '/v1/estimates/price', controller_name: 'estimates', action_name: 'estimates_price_get'
  # add_swagger_route 'GET', '/v1/estimates/time',  controller_name: 'estimates', action_name: 'estimates_time_get'
  # add_swagger_route 'GET', '/v1/products',        controller_name: 'products',  action_name: 'index'
  # add_swagger_route 'GET', '/v1/history',         controller_name: 'user',      action_name: 'history_get'
  # add_swagger_route 'GET', '/v1/me',              controller_name: 'user',      action_name: 'me_get'
end
