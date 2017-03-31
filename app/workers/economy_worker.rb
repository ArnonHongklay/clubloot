class EconomyWorker
  include Sidekiq::Worker

  def perform(*args)
    User.loot_economy
    Contest.tax_collected
  end
end
