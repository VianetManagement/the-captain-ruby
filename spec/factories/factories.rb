FactoryGirl.define do
  factory :ip_address, class: Hashie::Mash do
    value { Faker::Internet.ip_v4_address }
    event { [:import, :visit].sample }
    user { Faker::Number.number(2) }
  end

  factory :content, class: Hashie::Mash do
    value { Faker::Hacker.say_something_smart }
    event { [:bio, :import].sample }
    user { Faker::Number.number(2) }
  end

  factory :credit_card, class: Hashie::Mash do
    value { Faker::Internet.password }
    event { [:purchase_failed, :purchase_success].sample }
    user { Faker::Number.number(2) }
  end

  factory :email_address, class: Hashie::Mash do
    value { Faker::Internet.safe_email }
    event { [:import, :signup].sample }
    user { Faker::Number.number(2) }
  end

  factory :user, class: Hashie::Mash do
    value { Faker::Number.number(2) }
    event { :import }

    ip_address { build(:ip_address, user: value) }
    content { build(:content, user: value) }
    email_address { build(:email_address, user: value) }
    credit_card { build(:credit_card, user: value) }

    trait :global_event do
      ip_address { build(:ip_address, user: value, event: event) }
      content { build(:content, user: value, event: event) }
      email_address { build(:email_address, user: value, event: event) }
      credit_card { build(:credit_card, user: value, event: event) }
    end

  end
end
