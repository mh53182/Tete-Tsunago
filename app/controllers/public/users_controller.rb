class Public::UsersController < ApplicationController
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
  end

  def confirm
    @user = User.find(params[:user_id])
  end

  def withdraw
    user = current_user
    user.update(is_active: false)
    reset_session
    redirect_to root_path,notice: "退会が完了しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :is_public, :profile_image)
  end

end
