class AddAplicativos < ActiveRecord::Migration
  def self.up
    create_table :aplicativos, :force => true do |t|
      t.string "nombre", :limit => 100, :null => false
      t.string "codigo", :limit => 20, :null => true, :default => nil
      t.string "descripcion", :limit => 100, :null => false
      t.integer "user_id"
    end

    add_column :users, :aplicativo_id, :integer
  end

  def self.down
    remove_column :users, :aplicativo_id

    drop_table :aplicativos


  end
end
