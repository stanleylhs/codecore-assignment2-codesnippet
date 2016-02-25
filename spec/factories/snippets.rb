# == Schema Information
#
# Table name: snippets
#
#  id         :integer          not null, primary key
#  title      :string
#  work       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind_id    :integer
#  user_id    :integer
#

FactoryGirl.define do
  factory :snippet do
    association :user, factory: :user
    association :kind, factory: :kind
    sequence(:title) { |n| "#{Faker::Company.bs}-#{n}" }
    work             { Faker::Lorem.paragraph }
    is_private       false
  end
end
