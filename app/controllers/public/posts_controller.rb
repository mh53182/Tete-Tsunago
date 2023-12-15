class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :redirect_unless_post_auther, only: [:edit, :update]

  def index
    @post = Post.new
    # @posts = Post.all
    if current_user
      @posts = Post.joins(:user).where("users.is_public = ? OR users.id = ?", true, current_user.id)
    else
      @posts = Post.joins(:user).where(users: { is_public: true })
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user

    # 非公開アカウントによる投稿詳細への直アクセスを制限
    unless @user.is_public || @user == current_user
      redirect_to posts_path, alert: "この投稿は非公開です"
    end
    @comment = Comment.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notece] = "投稿しました"
      redirect_to user_path(current_user)
    else
      flash[:alert] = "投稿内容に不備があります"
      redirect_to request.referer
      # 各ビュー完成後にrenderの分岐を記述する。flash.nowに変更する。
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
    params.require(:post).permit(:user_id, :child_id, :body, :category, :post_image)
  end

  # URL指定による他人の投稿編集制限
  def redirect_unless_post_auther
    post = Post.find(params[:id])
    if post.user_id != current_user.id
      redirect_to root_path, alert: "投稿したアカウント以外では編集はできません"
    end
  end

end
