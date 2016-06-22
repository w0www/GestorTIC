class IssueHasPosition < ActiveRecord::Base
  belongs_to :issues
  belongs_to :positions
  self.table_name = 'issue_has_positions'
end
