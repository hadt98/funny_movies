FactoryBot.define do
  factory :user do
    sequence(:email)  { |sn| "fakeemail#{sn}@gmail.com" }
    password { "123123" }
  end
end
