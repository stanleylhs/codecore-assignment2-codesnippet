# == Schema Information
#
# Table name: kinds
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe "Kinds", type: :request do
  describe "GET /kinds" do
    it "works! (now write some real specs)" do
      get kinds_path
      expect(response).to have_http_status(200)
    end
  end
end
