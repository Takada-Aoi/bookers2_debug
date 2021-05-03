class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  
  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}
  
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :follower, through: :relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  
  def follow(other_user)
    following　<<　other_user
  end 
  
  def unfollow(other_user)
   relationships.find_by(followed_id:other_user.id).destroy
  end
  
  def following?(other_user)
   following.include?(other_user)
  end 
  
end
