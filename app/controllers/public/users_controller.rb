class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit, :withdraw]
  before_action :redirect_unless_current_user, only: [:edit, :update, :confirm, :withdraw]

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールが更新されました"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :edit
    end
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
    @post = Post.new
  end

  def confirm
    @user = User.find(params[:id])
  end

  def withdraw
    user = current_user
    user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: "退会が完了しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :is_public, :profile_image)
  end

  # ゲストユーザーの確認
  def ensure_guest_user
    user = User.find(params[:id])
    if user.guest_user?
      redirect_to user_path(current_user), alert: "ゲストユーザーはプロフィールの編集・退会はできません"
    end
  end

  # URL指定による他人の情報編集制限
  def redirect_unless_current_user
    user = User.find(params[:id])
    if user.id != current_user.id
      redirect_to user_path(current_user), alert: "他のユーザーの編集・退会はできません"
    end
  end

end