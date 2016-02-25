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

require 'rails_helper'

RSpec.describe Snippet, type: :model do
  describe "validations" do
    it "doesn't allow creating a snippet with no title"
      s = Snippet.new
      s.valid?
      expect(s.errors).to have_key(:title)
    end
    it "requires a work section" do
      s = Snippet.new
      s.valid?
      expect(s.errors).to have_key(:work)
    end
    it "requies a unique title" do
      s = create(:snippet)
      s2 = build(:snippet, {title: s.title})
      s2.valid?
      expect(s2.errors).to have_key(:title)
    end
  end
end
