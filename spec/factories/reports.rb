FactoryBot.define do
  factory :report do
    reporter { nil }
    reportable { nil }
    reason { "MyString" }
  end
end
