class AddDepartments < ActiveRecord::Migration
  def self.up
    create_table :positions, :force => true do |t|
      t.string "nombre", :limit => 100, :null => false
      t.string "codigo", :limit => 20, :null => true, :default => nil
      t.string "descripcion", :limit => 100, :null => false
    end

    add_column :users, :position_id, :integer
  end

  def self.down

    drop_table :positions

    remove_column :users, :position_id
  end
end
