class Aplicativo < ActiveRecord::Base
  has_and_belongs_to_many :issues, :join_table => "issue_has_aplicativos"
  has_and_belongs_to_many :positions, :join_table => "aplicativo_has_positions"
  has_and_belongs_to_many :users, :join_table => "user_has_aplicativos"



  cattr_reader :per_page
  @@per_page = 25
  validates_presence_of :nombre, :codigo

  def to_s
    nombre
  end
end
