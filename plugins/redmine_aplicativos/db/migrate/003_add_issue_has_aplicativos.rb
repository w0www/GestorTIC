class AddIssueHasAplicativos < ActiveRecord::Migration
  def self.up
    create_table :issue_has_aplicativos, :id => false do |t|
      t.integer "aplicativo_id"
      t.integer "issue_id"
    end
  end

  def self.down
    drop_table :issue_has_aplicativos
  end
end

