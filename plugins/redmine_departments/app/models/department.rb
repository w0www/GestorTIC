class Department < ActiveRecord::Base
  has_and_belongs_to_many :issues, :join_table => "issue_has_departments"
  has_and_belongs_to_many :users

  cattr_reader :per_page
  @@per_page = 25
  validates_presence_of :name

  def to_s
    name
  end
end
