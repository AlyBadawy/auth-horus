FactoryBot.define do
  factory :role do
    role_name { Faker::Role.unique.name }
  end
end
