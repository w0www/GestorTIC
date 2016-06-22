class Aplicativo < ActiveRecord::Base
  has_and_belongs_to_many :issues, :join_table => "issue_has_aplicativos"
  has_many :users
  belongs_to :responsable, :class_name => "User"
  belongs_to :coordinador, :class_name => "User"

  cattr_reader :per_page
  @@per_page = 25
  validates_presence_of :nombre, :codigo

  acts_as_attachable :view_permission => :view_attachments, :delete_permission => :view_attachments


  def to_s
    nombre
  end
end
