class AddAplicativos < ActiveRecord::Migration
  def self.up
    create_table :aplicativos, :force => true do |t|
      t.string "nombre", :limit => 100, :null => false
      t.string "codigo", :limit => 20, :null => true, :default => nil
      t.string "descripcion", :limit => 100, :null => false
    end
  end

  def self.down
    drop_table :aplicativos
  end
end
