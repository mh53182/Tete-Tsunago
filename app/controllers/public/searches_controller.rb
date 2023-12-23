class Public::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @keyword = params[:keyword]
    @category = params[:category]

    if @keyword.blank? && @category.blank?
      flash[:alert] = "キーワードを入力、またはカテゴリを選択してください"
      redirect_back(fallback_location: user_path(current_user)) and return
    end

    if @model == "user" && @category.present?
      flash[:alert] = "ユーザー検索ではカテゴリは選択できません"
      redirect_back(fallback_location: user_path(current_user)) and return
    end

    if @model == "user"
      @records = User.search_for(@keyword).order(created_at: :desc).page(params[:page]).per(20)
    else
      @records = Post.search_for(@keyword, @category).order(created_at: :desc).page(params[:page]).per(20)
    end
    @post = Post.new
    
    # 検索結果がゼロの場合のビューでの表示に使用
    @records.count
  end

end