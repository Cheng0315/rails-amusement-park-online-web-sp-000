class UsersController < ApplicationController

  def index

  end

  def new
    @user = User.new
  end

  def create
    binding.pry
    if current_user
      redirect_to root_path
    else
      binding.pry
      @user = User.new(user_params)
      if @user.save && !@user.admin
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      elsif @user.save && @user.admin
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        redirect_to root_path
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:name, :happiness, :nausea, :admin, :tickets, :password, :height)
  end

end
