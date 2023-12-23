class Post < ApplicationRecord

  has_one_attached :post_image

  belongs_to :user
  belongs_to :child,   optional: true
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy

  validates :body, presence: true, length: { maximum:350 }

  enum category: { everyday: 0, success: 1, graduation: 2 }

  # 公開アカウントによる投稿の取得
  scope :from_public_users, -> { joins(:user).where(users: { is_public: true }) }
  
  # 有効アカウントによる投稿の取得
  scope :from_active_users, -> { joins(:user).where(users: { is_active: true }) }
  
  # フォローしているユーザーの投稿を取得
  scope :from_followings_of, ->(user) { where(user: user.followings) }

  # カテゴリカラムによる絞り込み
  scope :by_category, ->(category) { where(category: category) if category.present? }

  def get_post_image
    (post_image.attached?) ? post_image : 'no_post_image.jpg'
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(keyword, category = nil)
    query = from_public_users.from_active_users
    query = query.where("body LIKE ?", "%" + keyword + "%") if keyword.present?
    query = query.by_category(category) if category.present?
    query
  end

  # def self.search_for(keyword, category = nil)
  #   query = all
  #   query = where("body LIKE ?", "%" + keyword + "%")if keyword.present?
  #   query = query.by_category(category) if category.present?
  #   query
  # end

end
