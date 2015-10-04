class Goal < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :checkpoint
end
