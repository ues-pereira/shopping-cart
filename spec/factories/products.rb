FactoryBot.define do
  factory :product do
    name { "Product #{(65 + rand(26)).chr}" }
    price { 20.0 }
  end
end
