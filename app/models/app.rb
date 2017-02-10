class App < Struct.new(:region, :environment, :version)

  def initialize(attrs = {})
    defaults              = YAML.load_file('config/instance.yml') rescue nil
    attrs                 = (defaults || {}).with_indifferent_access.merge(attrs)
    attrs[:region]      ||= 'th'
    attrs[:environment] ||= ['production', 'provisioning'].include?(ENV['RAILS_ROOT']) ? 'staging' : ENV['RAILS_ROOT'] || 'development'
    attrs[:version]     ||= 'master'
    attrs.each_pair { |k, v| self[k] = v.inquiry }
  end

  def domain(subdomain = nil)
    protocol + '//' + case subdomain
                      when 'api'
                        "#{api_host}.#{root_domain}#{port}"
                      when 'admin'
                        "admin.#{root_domain}#{port}"
                      else
                        if environment.development?
                          "#{root_domain}#{port}"
                        else
                          "#{root_domain}"
                        end
                      end
  end

  def root_domain
    # if environment.development?
    #   'daydash.local'
    # else
    #   'daydash.co'
    # end
    'clubloot.com'
  end

  def protocol
    # environment.development? ? 'http:' : 'https:'
    'http'
  end

  def port
    ':1337' if environment.development?
  end

  def host
    case environment
    when 'alpha'
      'alpha'
    else
      ''
    end
  end

  def admin_host
    case environment
    when  'alpha'
      'alpha-admin'
    else
      'admin'
    end
  end

  def api_host
    case environment
    when  'alpha'
      'alpha-api'
    else
      'api'
    end
  end

  class << self
    attr_accessor :current

    def method_missing(meth, *args, &block)
      current.send(meth, *args, &block)
    end
  end

  self.current = new
end
