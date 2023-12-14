class Admin::CommentsController < ApplicationController

  def index
    @comments = Comment.includes(:post).all
  end

  def show
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @post_user = @post.user
    @comments = @post.comments
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:notice] = "コメントを削除しました"
    redirect_to admin_comments_path
  end

end
