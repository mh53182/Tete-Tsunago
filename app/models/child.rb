class Child < ApplicationRecord

  belongs_to :user
  has_many :posts
  # childrenテーブル内のレコード削除機能は実装しない予定のため'dependent: :destroy'記述無し

  validates :nickname, presence: true

end