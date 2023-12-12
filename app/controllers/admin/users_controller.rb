class Admin::UsersController < ApplicationController
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update
      flash[:notece] = "ユーザー情報の更新が完了しました"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :edit
    end
  end
  
end
