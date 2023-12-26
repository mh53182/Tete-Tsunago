# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # sessionのcreateをオーバーライド
  # 誕生日判定メソッドをbefore_actionで使うとフラッシュメッセージが上書きされるため、誕生日判定をログイン後に行う
  def create
    super do |resource|
      check_birthdays if resource.persisted?
    end
  end

  # ゲストログイン
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "ゲストユーザーとしてログインしました"
  end

  private

  # 退会済アカウントのログイン不可処理
  def user_state
    user = User.find_by(email: params[:user][:email])
    return redirect_to new_user_session_path, alert: "ユーザーが存在しません。正しいメールアドレスを入力してください。" if user.nil?
    return unless user.valid_password?(params[:user][:password])
    return if user.is_active
    flash[:alert] = "すでに退会されたアカウントです。別のメールアドレスをお使いください。"
    redirect_to new_user_session_path
  end

  # お子様の誕生日判定
  def check_birthdays
    
    # ユーザーに紐づけられたお子様がいるかどうかを確認
    return if current_user.children.blank?

    current_user.children.each do |child|
      
      # お子様の誕生日が設定されているか確認
      next if child.birthday.blank?

      # お子様の誕生日と今日の日付が一致するか確認
      if child.birthday.month == Date.today.month && child.birthday.day == Date.today.day
        
        # ログイン成功のフラッシュメッセージを保持
        existing_notice = flash[:notice].to_s
        
        # ログイン成功と誕生日のメッセージを作成
        flash[:notice] = "#{existing_notice}　#{child.nickname} のお誕生日 おめでとうございます！"
      end
    end
  end

end
