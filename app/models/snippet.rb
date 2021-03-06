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

class Snippet < ActiveRecord::Base
  belongs_to :kind
  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :work, presence: true
  # check this below
  validates :kind_id, presence: true

  def self.filtered_result(uid)
    if uid
      where("is_private = FALSE OR (is_private = TRUE AND user_id = ?)", uid)
    else
      where("is_private = FALSE")
    end
  end

  delegate :full_name, to: :user, prefix: true, allow_nil: :true
end
