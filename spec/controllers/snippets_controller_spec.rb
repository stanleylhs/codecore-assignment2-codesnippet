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

RSpec.describe SnippetsController, type: :controller do
  let(:kind) { create(:kind) }
  let(:snippet) { create(:snippet, kind: kind) }
  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
    it "instantiates a new Snippet object and sets it to @snippet" do
      get :new
      expect(assigns(:snippet)).to be_a_new(Snippet)
    end
  end

  describe "#create" do
    context "with valid attributes" do
      def valid_request
        post :create, snippet: attributes_for(:snippet)
      end
      it "creates a record in the database" do
        before_count = Snippet.count
        valid_request
        after_count = Snippet.count
        expect(after_count - before_count).to eq(1)
      end
      it "redirects to the snippet show page" do
        valid_request
        expect(response).to redirect_to(snippet_path(Snippet.last))   
      end
      it "sets a notice flash message" do
        valid_request
        expect(flash[:notice]).to be 
      end
    end

    context "with invalid attributes" do
        def invalid_request
          post :create, snippet: attributes_for(:snippet, title: "")
        end
        it "doesn't create a record in the database" do
          before_count = Snippet.count
          invalid_request
          after_count = Snippet.count
          expect(after_count - before_count).to eq(0)
        end
        it "renders the new template" do 
          invalid_request
          expect(response).to render_template(:new)      
        end
        it "sets an alert flash message" do
          invalid_request
          expect(flash[:alert]).to be 
        end
      end
  end

  describe "#show" do
    before do
      snippet
      get :show, id: snippet.id
    end
    it "renders the show template" do
      expect(response).to render_template(:show)
    end
    it "finds the object by its id and sets to to @snippet variable" do
      expect(assigns(:snippet)).to eq(snippet)
    end


    it "raises an error if the id passed doesn't match a record in the DB" do
      # Never wrote an explicit number like 689, as you test suite grow it will reach that number. Use the last and add on that.
      expect{ get :show, id: snippet.id + 1000 }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
    it "fetches all records and assigns them to @snippets" do 
      s  = create(:snippet)
      s1 = create(:snippet)
      get :index
      expect(assigns(:snippets)).to eq([s, s1])
    end
  end

  describe "#edit" do
    before do
      get :edit, id: snippet.id
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
    it "finds the snippet by id and sets it to @snippet instance variable" do
      expect(assigns(:snippet)).to eq(snippet)
    end
  end

  describe "#udpate" do
    context "with valid attributes" do
      before do
        patch :update, id: snippet.id, snippet: {title: "new valid name"}
      end
      it "updates the records with new parameter(s)" do
        expect(snippet.reload.title).to eq("new valid name")
      end
      it "redirects to the snippet show page" do
        expect(response).to redirect_to(snippet)      
      end
      it "sets a flash message" do
        expect(flash[:notice]).to be
      end

    end
    context "with invalid attributes" do
      def invalid_update
        patch :update, id: snippet.id, snippet: {title: ""}
      end
      it "doesn't update the record" do 
        before_title = snippet.title
        invalid_update
        expect(snippet.reload.title).to eq(before_title)
      end
      it "renders the edit template" do
        invalid_update
        expect(response).to render_template(:edit)      
      end
      it "sets a flash alert message" do
        invalid_update
        expect(flash[:alert]).to be
      end

    end  
  end

  describe "#destroy" do
    def delete_snippet 
      delete :destroy, id: snippet.id
    end
    it "removes the snippets from the database" do
      # signin(user)
      snippet
      expect { delete_snippet }.to change { Campaign.count }.by(-1)
      # snippet
      # before_count = Campaign.count
      # puts ">>>>>>>"
      # puts snippet.inspect
      # puts user.inspect
      # puts ">>>>>>>"
      # delete :destroy, id: snippet
      # after_count = Campaign.count
      # expect(before_count - after_count).eq_to (1)
    end
    it "redirects to the snippet index page" do
      delete_snippet 
      expect(response).to redirect_to(snippets_path)
    end
    it "Sets a flash message" do
      delete_snippet 
      expect(flash[:notice]).to be
    end
  end

end
