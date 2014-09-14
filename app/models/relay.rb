class Relay < ActiveRecord::Base
  belongs_to :officer

  default_scope { order(:from) }
  scope :include_officer, -> { includes(:officer) }

  before_validation :complete_from

  validates :from, email: true, length: { maximum: 50 }, format: { with: /@icu\.ie\z/ }, uniqueness: true
  validates :to, email_list: true, length: { maximum: 255 }
  validates :provider_id, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :officer_id, numericality: { integer_only: true, greater_than: 0 }, allow_nil: true

  private

  def complete_from
    if from.present? && !from.match(/@/)
      self.from += "@icu.ie"
    end
  end

  def self.refresh
    actuals = get_provider_relays
    current = get_database_relays
    actuals.each do |from, route|
      if relay = current[from]
        relay.to = route[:to]
        relay.provider_id = route[:id]
        relay.save! if relay.changed?
      else
        Relay.create!(from: from, to: route[:to], provider_id: route[:id])
      end
    end
    current.each do |from, relay|
      unless actuals[from]
        relay.destroy
      end
    end
    true
  rescue => e
    Failure.log("UpdateOfficerRedirects", exception: e.class.to_s, message: e.message)
    false
  end

  # The actual relays are what the provider defines.
  def self.get_provider_relays
    routes = Util::Mailgun.routes.each_with_object({}) do |route, hash|
      next if route["expression"].match(/\Acatch_all/)
      if route["expression"].to_s.match(/\Amatch_recipient\(["'](\w+@icu\.ie)["']\)\z/)
        from = $1
      else
        raise "couldn't parse expression in #{route}"
      end
      to = []
      if route["actions"].is_a?(Array)
        route["actions"].each do |action|
          next if action.match(/\Astop\(\)\z/)
          if action.match(/\Aforward\(["']([^"'\s]+)["']\)\z/)
            to.push($1)
          else
            raise "unrecognised action in #{route}"
          end
        end
      else
        raise "expected array of actions in #{route}"
      end
      if route["id"].present?
        id = route["id"]
      else
        raise "couldn't get ID for #{route}"
      end
      to = to.empty?? nil : to.sort.join(", ")
      hash[from] = { id: id, to: to }
    end
    raise "unexpectedly low number of routes" unless routes.size > 20
    routes
  end

  # These are the relays currently in the ICU database which might be out of sync with the provider's.
  def self.get_database_relays
    Relay.all.each_with_object({}) do |relay, hash|
      hash[relay.from] = relay
    end
  end

  private_class_method :get_provider_relays, :get_database_relays
end