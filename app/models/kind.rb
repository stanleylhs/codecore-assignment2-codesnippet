# == Schema Information
#
# Table name: kinds
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Kind < ActiveRecord::Base
  KINDS_STRING = ["Ruby","JavaScript","HTML","CSS"]

  has_many :snippets, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
