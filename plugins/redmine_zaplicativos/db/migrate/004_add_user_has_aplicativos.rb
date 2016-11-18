class AddUserHasAplicativos < ActiveRecord::Migration
  def self.up
    create_table :user_has_aplicativos, :id => false do |t|
      t.integer "aplicativo_id"
      t.integer "user_id"
    end
  end

  def self.down
    drop_table :user_has_aplicativos
  end
end

