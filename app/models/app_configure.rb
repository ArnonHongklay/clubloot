class AppConfigure
  include Mongoid::Document
  field :ruby, type: Hash
  field :sapphire, type: Hash
  field :emerald, type: Hash
  field :diamond, type: Hash

  field :daily_loot, type: Integer
  field :min_consecutive, type: Integer
  field :max_consecutive, type: Integer
  field :more_coin, type: Integer

  def self.exchange(user, type)
    gemc = first

    case type
    when 'sapphire'
      raise "coins or ruby less" if user.coins < gemc.ruby[:fee].to_i or user.rubies < gemc.ruby[:rate].to_i
      amount_coins = gemc.sapphire[:fee].to_i
      amount_from  = gemc.ruby[:rate].to_i
      amount_to    = 1

      user.coins     = user.coins - amount_coins
      user.rubies    = user.rubies - amount_from
      user.sapphires = user.sapphires + amount_to

      from = 'rubies'
      to = 'sapphires'
    when 'emerald'
      raise "coins or sapphire less" if user.coins < gemc.sapphire[:fee].to_i or user.sapphires < gemc.sapphire[:rate].to_i
      amount_coins = gemc.emerald[:fee].to_i
      amount_from  = gemc.sapphire[:rate].to_i
      amount_to    = 1

      user.coins     = user.coins - amount_coins
      user.sapphires = user.sapphires - amount_from
      user.emeralds  = user.emeralds + amount_to

      from = 'sapphires'
      to = 'emeralds'
    when 'diamond'
      raise "coins or emerald less" if user.coins < gemc.emerald[:fee].to_i or user.emeralds < gemc.emerald[:rate].to_i
      amount_coins = gemc.diamond[:fee].to_i
      amount_from  = gemc.emerald[:rate].to_i
      amount_to    = 1

      user.coins     = user.coins - amount_coins
      user.emeralds  = user.emeralds - amount_from
      user.diamonds  = user.diamonds + amount_to

      from = 'emeralds'
      to = 'diamonds'
    end

    user.save!

    transactions = []

    transactions << OpenStruct.new(
      status: 'complete',
      format: 'Convert Gem',
      action: 'minus',
      description: 'Convert Gem',
      from: 'coins',
      to: to,
      unit: 'coins',
      amount: amount_coins,
      tax: 0
    )

    transactions << OpenStruct.new(
      status: 'complete',
      format: 'Convert Gem',
      action: 'minus',
      description: 'Convert Gem',
      from: from,
      to: to,
      unit: from,
      amount: amount_from,
      tax: 0
    )

    transactions << OpenStruct.new(
      status: 'complete',
      format: 'Convert Gem',
      action: 'plus',
      description: 'Convert Gem',
      from: to,
      to: "#{from} & coins",
      unit: to,
      amount: amount_to,
      tax: 0
    )

    Ledger.create_transactions(user, transactions)
  end
end
