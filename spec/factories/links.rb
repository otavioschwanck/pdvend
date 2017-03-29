FactoryGirl.define do
  factory :link do
    url { FFaker::Internet.http_url }
  end
end
