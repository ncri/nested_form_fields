class UsersController < ApplicationController


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes params.require(:user).permit(:name, projects_attributes: [:name, :description, todos: [:description]]))
      flash.now[:notice] = 'User saved'
    end
    render :edit
  end


  def show
  end


  def new
  	@user = User.new
  	render action: :edit
  end


  def create
    @user = User.new(params.require(:user).permit(:name, projects_attributes: [:name, :description, todos: [:description]]))
    if @user.save
      flash[:notice] = 'User Created'
      redirect_to edit_user_path(@user)
    else
      render :new
    end
  end
end
