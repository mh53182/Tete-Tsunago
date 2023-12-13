class Post < ApplicationRecord

  has_one_attached :post_image

  belongs_to :user
  belongs_to :child
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy

  validates :body, presence: true, length: { maximum:350 }

  enum category: { everyday: 0, success: 1, graduation: 2 }

  def get_post_image
    (post_image.attached?) ? post_image : 'no_post_image.jpg'
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(key_word)
    Post.where('body LIKE ?', '%' + key_word + '%')
  end

end
