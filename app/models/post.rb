class Post < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy

  validates :body, presence: true, length: { maximum:350 }
  
  enum category: { everyday: 0, success: 1, graduation: 2 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
end
