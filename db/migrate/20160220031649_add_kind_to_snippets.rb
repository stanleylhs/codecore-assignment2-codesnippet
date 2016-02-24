class AddKindToSnippets < ActiveRecord::Migration
  def change
    add_reference :snippets, :kind, index: true, foreign_key: true
  end
end
