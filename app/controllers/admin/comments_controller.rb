class Admin::CommentsController < ApplicationController
  
  def index
    @comments = Comments.all
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:notice] = "コメントを削除しました"
    redirect_to request.referer
  end
  
end
