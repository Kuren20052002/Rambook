require "open-uri"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_picture
  has_one_attached :cover_picture
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :follower_users, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_users, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :following_users, source: :followed, dependent: :destroy
  has_many :followers, through: :follower_users, source: :follower, dependent: :destroy
  has_many :hearts, dependent: :destroy
  after_create :get_default_profile_picture
  attr_writer :login

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, inclusion: { in: [ "boy", "girl" ], message: "%{value} is not a valid gender" }

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where([ "lower(username) = :value OR lower(email) = :value", { value: login.downcase } ]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

  def following?(user)
    followings.include?(user)
  end

  def follow(user)
    followings << user unless self == user
  end

  def unfollow(user)
    followings.delete(user)
  end

  def follow_count
    followings.count
  end

  after_create_commit do
    broadcast_update_to "user_#{self.user_id}_follows", target: "follows/follow_button"
  end

  after_destroy_commit do
    broadcast_update_to "user_#{self.user_id}_follows", target: "follows/follow_button"
  end


  private

  def get_default_profile_picture
    url = "https://avatar.iran.liara.run/public/#{self.gender}?username=#{self.username}"

    begin
      profile_picture = URI.open(url)
      self.profile_picture.attach(io: profile_picture, filename: "#{self.username}_profile_pic.jpg")
    rescue => e
      Rails.logger.error("Error fetching profile picture: #{e.message}")
      Rails.logger.error("Backtrace:\n#{e.backtrace.join("\n")}")
      Rails.logger.error("Using default picture")

      default_picture_path = Rails.root.join("app", "assets", "images", "default_profile_picture.png")
      default_picture = File.open(default_picture_path)
      self.profile_picture.attach(io: default_picture, filename: "default_profile_pic.png")
    end
  end
end
