class IssueHasAplicativo < ActiveRecord::Base
  belongs_to :issues
  belongs_to :aplicativos
  self.table_name = 'issue_has_aplicativos'
end
