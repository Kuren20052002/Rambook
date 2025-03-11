class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one_attached :image
  has_many :hearts, as: :heartable, dependent: :destroy

  validates :body, presence: true, if: -> { !image.attached? }
end
