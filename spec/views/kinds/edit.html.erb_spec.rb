require 'rails_helper'

RSpec.describe "kinds/edit", type: :view do
  before(:each) do
    @kind = assign(:kind, Kind.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit kind form" do
    render

    assert_select "form[action=?][method=?]", kind_path(@kind), "post" do

      assert_select "input#kind_name[name=?]", "kind[name]"
    end
  end
end
