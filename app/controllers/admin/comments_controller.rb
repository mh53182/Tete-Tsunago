class Admin::CommentsController < ApplicationController

  def index
    @comments = Comment.includes(:post).all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    # @comment = Comment.find(params[:id])
    @post = @comment.post
    @post_user = @post.user
    @comments = @post.comments
  end

  # 投稿詳細モーダルからの削除用アクション
  def destroy_modal
    destroy_comment
    @post = @comment.post
  end

  # コメント一覧からの削除用
  def destroy_index
    destroy_comment
    redirect_to admin_comments_path
  end

  private

  def destroy_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "コメントを削除しました"
  end

end
