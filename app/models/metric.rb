class Metric < ApplicationRecord
  belongs_to :agent
  has_one :varbind
end
