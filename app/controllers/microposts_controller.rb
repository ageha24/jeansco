class MicropostsController < ApplicationController
  def new
    @micropost = Micropost.new
    @user = current_user
  end

  def create
    @user = current_user

    @micropost = current_user.microposts.new(microposts_params)
    if @micropost.save
      flash[:success] = '投稿しました'
      redirect_to microposts_path
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def index
    @user = current_user
    if params[:search]
      @micropost = Micropost.paginate(page: params[:page], :per_page => 2).where('denimname LIKE ?', "%#{params[:search]}%")
    else
      @micropost = Micropost.paginate(page: params[:page], :per_page => 2)
    end
  end

  def show
    @user = current_user
    @micropost = Micropost.find(params[:id])
    @likes = Like.where(micropost_id: params[:micropost_id])
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(microposts_params)
      flash[:success] = "投稿内容が更新されました。"
      redirect_to @micropost
    else
      flash.now[:danger] = "投稿内容の更新に失敗しました"
      render 'edit'
  end
end

  def destroy
    Micropost.find(params[:id]).destroy
    flash[:success] = "投稿が削除されました"
    redirect_to microposts_url
  end

  private
  def microposts_params
    params.require(:micropost).permit(:denimname,:brandname,:type,:color,:image,:comment,
                                        :popular,:fit,:price,:design)
  end
end
