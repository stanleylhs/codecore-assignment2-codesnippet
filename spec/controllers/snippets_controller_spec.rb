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
  let(:user) { create(:user) }
  # public && owner
  let(:snippet) { create(:snippet, user: user, kind: kind) }
  # public && !owner
  let(:snippet_public_not_owner) {create(:snippet, kind: kind) }
  # private && owner
  let(:snippet_private_owner) {create(:snippet, kind: kind, user: user, is_private: true) }
  # private && !owner
  let(:snippet_private_not_owner) {create(:snippet, kind: kind, is_private: true) }
  describe "#new" do
    context "without signed user" do
      it "redirects user to signin" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with signed in user" do
      before { signin(user) }
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
      it "instantiates a new Snippet object and sets it to @snippet" do
        get :new
        expect(assigns(:snippet)).to be_a_new(Snippet)
      end
    end
  end

  describe "#create" do
    def valid_request
      # attributes_for don't passs you the assc!!!
      post :create, snippet: attributes_for(:snippet, kind_id: kind.id)
    end
    context "without signed user"do
      it "redirects user to signin" do
        valid_request
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with signed in user" do
      before { signin(user) }
      context "with valid attributes" do
        it "creates a record in the database" do
          before_count = Snippet.count
          # binding.remote_pry
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
  end

  # TODO: refactor
  describe "#show" do
    it "raises an error if the id passed doesn't match a record in the DB" do
      snippet
      # Never wrote an explicit number like 689, as you test suite grow it will reach that number. Use the last and add on that.
      expect{ get :show, id: Snippet.last.id + 1000 }.to raise_error(ActiveRecord::RecordNotFound)
    end
    context "without sign in" do
      def show_request
        snippet
        get :show, id: snippet.id
      end
      it "renders the show template" do
        show_request
        expect(response).to render_template(:show)
      end
      it "redirects to root for private snippet which user don't own" do
        snippet_private_not_owner
        get :show, id: snippet_private_not_owner.id
        expect(response).to redirect_to(root_path)
      end
      it "finds the object by its id and sets to to @snippet variable" do
        show_request
        expect(assigns(:snippet)).to eq(snippet)
      end
    end
    context "with sign in" do
      before { signin(user) }
      before do
        snippet_private_owner
        get :show, id: snippet_private_owner.id
      end
      it "renders the show template" do
        expect(response).to render_template(:show)
      end
      it "finds the object by its id and sets to to @snippet variable" do
        expect(assigns(:snippet)).to eq(snippet_private_owner)
      end
    end
  end

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
    def index_request
      snippet # public && owner
      snippet_public_not_owner
      snippet_private_owner
      snippet_private_not_owner
      get :index
    end
    context "without signed user" do
      it "fetches all correct records and assigns them to @snippets" do
        index_request
        expect(assigns(:snippets)).to match_array([snippet, snippet_public_not_owner])
      end
    end
    context "with signed in user" do
      before { signin(user) }
      it "fetches all correct records and assigns them to @snippets" do
        index_request
        expect(assigns(:snippets)).to match_array([snippet, snippet_public_not_owner, snippet_private_owner])
      end
    end
  end

  # start here
  describe "#edit" do
    context "without signin user" do
      it "redirects user to signin" do
        get :edit, id: snippet.id
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with signin user" do
      before { signin(user) }
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
  end

  describe "#udpate" do
    def update_request
      patch :update, id: snippet.id, snippet: {title: "new valid name"}
    end
    context "without signin user" do
      it "redirects user to signin" do
        update_request
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with signin user" do
      before { signin(user) }
      context "update snippet that user doesn't own" do
        it "redirects to root for snippet which user don't own" do
          patch :update, id: snippet_private_not_owner.id, snippet: {title: "new valid name"}
          expect(response).to redirect_to(root_path)
        end
      end
      context "update a snippet that the user own" do
        context "with valid attributes" do
          before do
            update_request
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
    end
  end

  describe "#destroy" do
    def delete_snippet
      delete :destroy, id: snippet.id
    end
    context "without signin user" do
      it "redirects user to signin" do
        delete_snippet
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with signin user" do
      before { signin(user) }
      context "delete snippet that user doesn't own" do
        it "redirects to root for snippet which user don't own" do
          delete :destroy, id: snippet_private_not_owner.id
          expect(response).to redirect_to(root_path)
        end
      end
      context "update a snippet that the user own" do
        it "removes the snippets from the database" do
          snippet
          expect { delete_snippet }.to change { Snippet.count }.by(-1)

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
  end

end
