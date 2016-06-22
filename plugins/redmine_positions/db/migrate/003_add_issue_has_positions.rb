class AddIssueHasPositions < ActiveRecord::Migration
  def self.up
    create_table :issue_has_positions, :id => false do |t|
      t.integer "position_id"
      t.integer "issue_id"
    end
  end

  def self.down
    drop_table :issue_has_positions
  end
end

