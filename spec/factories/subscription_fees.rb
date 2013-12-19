FactoryGirl.define do
  factory :subscription_fee do
    category          "standard"
    amount            35.0
    season_desc       { Season.new.desc }
  end
end