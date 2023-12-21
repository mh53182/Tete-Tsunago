class Admin::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @keyword = params[:keyword]

    if @keyword.blank?
      flash[:alert] = "キーワードを入力してください"
      redirect_back(fallback_location: admin_root_path) and return
    end

    case @model
    when "user"
      @records = User.where("name LIKE ?", "%" + @keyword + "%").order(created_at: :desc)
    when "post"
      @records = Post.where("body LIKE ?", "%" + @keyword + "%").order(created_at: :desc)
    when "comment"
      @records = Comment.where("body LIKE ?", "%" + @keyword + "%").order(created_at: :desc)
    end
  end

end