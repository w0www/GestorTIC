class AplicativonHasPositions < ActiveRecord::Base
  belongs_to :aplicativos
  belongs_to :positions
  self.table_name = 'aplicativo_has_positions'
end
