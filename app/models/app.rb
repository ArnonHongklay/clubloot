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
    domain = case subdomain
    when 'api'
      "#{host('api')}.#{root_domain}"
    when 'admin'
      "admin.#{root_domain}"
    else
      root_domain
    end

    protocol + '//' + domain
  end

  def root_domain
    if environment.development?
      'clubloot.local' + port
    else
      'clubloot.com'
    end
  end

  def protocol
    # environment.development? ? 'http:' : 'https:'
    'http:'
  end

  def port
    ':5000' if environment.development?
  end

  def host(subdomain = nil)
    case environment
    when 'staging', 'alpha'
      subdomain.nil? ? 'alpha' : "alpha-#{subdomain}"
    else
      "#{subdomain}"
    end
  end

  def generate_code(digit = 5)
    o = [(0..9), ('A'..'Z')].map { |i| i.to_a }.flatten
    o = o - [0 , 'O', 'I', 'L', 1]
    (0...digit).map { o[rand(o.length)] }.join
  end

  def currency_unit
    ['coins', 'rubies', 'sapphires', 'emeralds', 'diamonds']
  end

  class << self
    attr_accessor :current

    def method_missing(meth, *args, &block)
      current.send(meth, *args, &block)
    end
  end

  self.current = new
end

class Loot
  include Mongoid::Document
  store_in collection: "dailies"

  field :base, type: Integer
  field :minConsecutive, type: Integer
  field :maxConsecutive, type: Integer
  field :moreCoin, type: Integer
end

class GemConvert
  include Mongoid::Document
  store_in collection: "gemcs"

  field :ruby,      type: Hash
  field :sapphire,  type: Hash
  field :emerald,   type: Hash
  field :diamond,   type: Hash

  def self.exchange(user, type)
    gemc = first

    case type
    when 'sapphire'
      raise "coins or ruby less" if user.coins < gemc.ruby[:fee].to_i or user.rubies < gemc.ruby[:rate].to_i
      user.coins     = user.coins - gemc.sapphire[:fee].to_i
      user.rubies    = user.rubies - gemc.ruby[:rate].to_i
      user.sapphires = user.sapphires + 1
    when 'emerald'
      raise "coins or sapphire less" if user.coins < gemc.sapphire[:fee].to_i or user.sapphires < gemc.sapphire[:rate].to_i
      user.coins     = user.coins - gemc.emerald[:fee].to_i
      user.sapphires = user.sapphires - gemc.sapphire[:rate].to_i
      user.emeralds  = user.emeralds + 1
    when 'diamond'
      raise "coins or emerald less" if user.coins < gemc.emerald[:fee].to_i or user.emeralds < gemc.emerald[:rate].to_i
      user.coins     = user.coins - gemc.diamond[:fee].to_i
      user.emeralds  = user.emeralds - gemc.emerald[:rate].to_i
      user.diamonds  = user.diamonds + 1
    end

    user.save!
  end
end
