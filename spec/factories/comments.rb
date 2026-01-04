FactoryBot.define do
  factory :comment do
    discussion { "" }
    user { "" }
    body { "MyText" }
  end
end
