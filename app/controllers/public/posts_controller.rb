class Public::PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notece] = "投稿しました"
      redirect_to user_path(current_user)
    else
      flash[:alert] = "投稿内容に不備があります"
      redirect_to request.referer　# 各ビュー完成後にrenderの分岐を記述する。flash.nowに変更する。
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

end
