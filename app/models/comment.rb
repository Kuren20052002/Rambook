class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one_attached :image

  validates :body, presence: true, if: -> { !image.attached? }
end
