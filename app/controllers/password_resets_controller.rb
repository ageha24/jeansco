class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit,:update]
  # before_action :valid_user, only:[:edit,:update]
  before_action :check_expiration, only:[:edit,:update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = "宛先に送られたリンク先をクリックして、再設定を行ってください"
    redirect_to root_url
  else
    flash.now[:danger] = "宛先が見つかりません"
    render 'new'
  end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @users.errors.add(:password,:blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "パスワードが更新されました"
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

  def user_params
    params.require(:user).permit(:password,:password_confirmation)
  end

  # beforeフィルター
  def get_user
    @user = User.find_by(email: params[:email])
  end

  

  # トークンが期限切れかどうか確認する
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "パスワード更新が有効切れです"
      redirect_to new_password_reset_url
    end
  end
end
