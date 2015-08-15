class Checkpoint < ActiveRecord::Base

  validates :CheckpointID, presence: true, length: { maximum: 3 }, uniqueness: { case_sensitive: false }
  validates :GridReference, presence: true, length: { maximum: 9 }
  validates :CheckpointDescription, presence: true, length: { maximum: 255 }

end
