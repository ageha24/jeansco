class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @micropost = @user.microposts.paginate(page: params[:page], :per_page => 2)
    @likes = Like.where(micropost_id: params[:micropost_id])
    @like_microposts = current_user.like_microposts
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "会員登録が完了しました。"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(updateuser_params)
      flash[:success] = "プロフィールが更新されました。"
      redirect_to @user
    else
      render 'edit'
  end
end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーが削除されました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end

  def updateuser_params
    params.require(:user).permit(:name,:email,:gender,:profileimage,:introduce,:password,:password_confirmation)
  end
end
