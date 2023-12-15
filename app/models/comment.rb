class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  validates :body, presence: true

  def self.search_for(key_word)
    Comment.where('body LIKE ?', '%' + key_word + '%')
  end

end