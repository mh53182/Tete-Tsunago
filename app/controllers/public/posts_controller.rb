class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_post_auther, only: [:edit, :update, :destroy]

  def index
    @post = Post.new
    # 有効かつ公開ユーザーの投稿の取得
    base_query = Post.from_active_users.from_public_users

    # 取得したクエリにログイン中ユーザーの投稿を追加
    if current_user
      user_posts = Post.where(user: current_user)
      base_query = base_query.or(user_posts)
    end

    # 上記クエリにカテゴリ絞り込みがある場合は実施し、新着順に表示
    @posts = base_query.by_category(params[:category]).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user

    # 非公開アカウントおよび退会アカウントの投稿詳細への直アクセスを制限
    unless @user.is_active && (@user.is_public || @user == current_user)
      redirect_to posts_path, alert: "アクセスできません"
    end
    @comment = Comment.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "投稿内容に不備があります"
      @user = current_user
      @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(20)
      render template: "public/users/show"
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿が更新されました"
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "更新できませんでした"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to request.referer
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :child_id, :body, :category, :post_image, :start_time)
  end

  # URL指定による他人の投稿編集制限
  def redirect_unless_post_auther
    post = Post.find(params[:id])
    if post.user_id != current_user.id
      redirect_to root_path, alert: "投稿したアカウント以外では編集はできません"
    end
  end

end
