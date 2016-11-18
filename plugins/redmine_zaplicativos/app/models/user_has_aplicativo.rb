class UserHasAplicativo < ActiveRecord::Base
  belongs_to :users
  belongs_to :aplicativos
  self.table_name = 'user_has_aplicativos'
end
