class Heart < ApplicationRecord
  belongs_to :user
  belongs_to :heartable, polymorphic: true

  def self.hearted?(user, heartable)
    where(user: user, heartable: heartable).exists?
  end
end
