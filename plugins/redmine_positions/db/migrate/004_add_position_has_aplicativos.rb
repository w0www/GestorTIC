class AddPositionHasAplicativos < ActiveRecord::Migration
  def self.up
    create_table :aplicativo_has_positions, :id => false do |t|
      t.integer "aplicativo_id"
      t.integer "position_id"
    end
  end

  def self.down
    drop_table :aplicativo_has_positions
  end
end
