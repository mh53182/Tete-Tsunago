class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :posts,     dependent: :destroy
  has_many :children,  dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy

  # 以下、フォロー/フォロワー機能
  # フォローしている関係
  has_many :active_relationships,  class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされている関係
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 自分がフォローしているユーザーの取得
  has_many :followings, through: :active_relationships,  source: :followed
  # 自分をフォローしてくれているユーザーの取得
  has_many :followers,  through: :passive_relationships, source: :follower

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
  # フォロー/フォロワー機能　ここまで

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 200 }

  # 公開アカウントの取得
  scope :is_public, -> { where(is_public: true) }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_profile_image.png'
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.introduction = "ゲストユーザーです"
    end
  end

  def guest_user?
    email == 'guest@example.com'
  end

  def not_current_user?
    user = User.find(params[:id])
    user.id != current_user.id
  end

  def self.search_for(key_word)
    User.where('name LIKE ?', '%' + key_word + '%')
  end

end
