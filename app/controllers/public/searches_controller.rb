class Public::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @keyword = params[:keyword]
    @category = params[:category]

    # 何も入力せず検索ボタン押下した際の処理
    if @keyword.blank? && @category.blank?
      flash[:alert] = "キーワードを入力、またはカテゴリを選択してください"
      redirect_back(fallback_location: user_path(current_user)) and return
    end

    # ユーザー検索時にカテゴリが選択されていた際の処理
    if @model == "user" && @category.present?
      flash[:alert] = "ユーザー検索ではカテゴリは選択できません"
      redirect_back(fallback_location: user_path(current_user)) and return
    end

    # ビューに表示する検索内容を格納
    @search_description = generate_search_description(@keyword, @category)

    if @model == "user"
      @records = User.search_for(@keyword).order(created_at: :desc).page(params[:page]).per(20)
    else
      @records = Post.search_for(@keyword, @category).order(created_at: :desc).page(params[:page]).per(20)
    end
    @post = Post.new

    # 検索結果がゼロの場合のビューでの表示に使用
    @records.count
  end

  private

  # キーワードかつカテゴリ検索時に見出しに"/"を挿入するメソッド
  def generate_search_description(keyword, category)
    description = ""
    description += keyword unless keyword.blank?
    description += " / " if keyword.present? && category.present?
    description += Post.new(category: category).category_i18n unless category.blank?
    description
  end

end