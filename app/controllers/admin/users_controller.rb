class Admin::UsersController < ApplicationController

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(20)
    @comments = @user.comments
  end

  def edit
    @user = User.find(params[:id])
    
    # editページへのアクセス元（indexまたはshowまたは検索結果表示）のセッションへの保存
    session[:previous_url] = request.referer
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報の更新が完了しました"
      
      # セッションに保存したeditページへのアクセス元へリダイレクト
      redirect_to session[:previous_url]
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :is_active)
  end

end
