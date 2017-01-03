FactoryGirl.define do
  factory :ip_address, class: Hashie::Mash do
    value { Faker::Internet.ip_v4_address }
    event { TheCaptain::IpAddress::EVENT_OPTIONS.keys.sample }
    flag { [Faker::Hacker.verb, nil].sample }
  end

  factory :content, class: Hashie::Mash do
    value { Faker::Hacker.say_something_smart }
    event { TheCaptain::Content::EVENT_OPTIONS.keys.sample }
    flag { [Faker::Hacker.verb, nil].sample }
  end

  factory :credit_card, class: Hashie::Mash do
    value { Faker::Internet.password }
    event { TheCaptain::CreditCard::EVENT_OPTIONS.keys.sample }
    flag { [Faker::Hacker.verb, nil].sample }
  end

  factory :email_address, class: Hashie::Mash do
    value { Faker::Internet.safe_email }
    user { Faker::Number.number(2) }
    flag { [Faker::Hacker.verb, nil].sample }
  end

  factory :user, class: Hashie::Mash do
    value { Faker::Number.number(2) }
    flag { [Faker::Hacker.verb, nil].sample }

    ip_address { build(:ip_address) }
    content { build(:content) }
    email_address { build(:email_address) }
    credit_card { build(:credit_card) }
  end
end
