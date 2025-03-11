class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :hearts, as: :heartable, dependent: :destroy
  has_one_attached :image

  validates :body, presence: true, if: -> { !image.attached? }
end
