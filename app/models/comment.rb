class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  validates :body, presence: true

  def self.search_for(keyword)
    Comment.where('body LIKE ?', '%' + keyword + '%')
  end

end