# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :user do
    first_name       { Faker::Name.first_name }
    last_name        { Faker::Name.last_name }
    sequence(:email) {|n| "#{n}-#{Faker::Internet.email}" }
    password         { Faker::Internet.password }
  end
end
