class Public::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @keyword = params[:keyword]
    @category = params[:category]

    if @keyword.blank? && @category.blank?
      flash[:alert] = 'キーワードまたはカテゴリを選択してください。'
      redirect_back(fallback_location: root_path) and return
    end

    if @model == "user"
      @records = User.search_for(@keyword)
    else
      @records = Post.search_for(@keyword, @category)
    end
    @post = Post.new
  end

end