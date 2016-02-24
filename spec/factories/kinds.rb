# == Schema Information
#
# Table name: kinds
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :kind do
    # instead of delibratly randomizing one elem from array, use sample()
    name { Kind::KINDS_STRING.sample }
    # Factory will delete your obj after test.
  end
end
