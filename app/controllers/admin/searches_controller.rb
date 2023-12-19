class Admin::SearchesController < ApplicationController
  
  # def search
  #   @keyword = params[:keyword]
  #   @category = params[:category]
  #   @records = Post.all.search_for(@keyword, @category)
    
    
    
  #   # その他のロジック ...
  # end
  
  
  
  def search
    @model = params[:model]
    @keyword = params[:keyword]
    
    if @keyword.blank?
      flash[:alert] = 'キーワードを入力してください'
      redirect_back(fallback_location: admin_root_path) and return
    end
  
    case @model
    when "user"
      @records = User.where("name LIKE ?", "%" + @keyword + "%")
    when "post"
      @records = Post.where("body LIKE ?", "%" + @keyword + "%")
    when "comment"
      @records = Comment.where("body LIKE ?", "%" + @keyword + "%")
    end
  end
  
end
