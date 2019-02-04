class UsersController < ApplicationController

  def index

  end

  def new
    @user = User.new
  end

  def create
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

  def show
    @user = User.find(params[:id])
  end

  def update
    binding.pry
    att = Attraction.find(params[:id])

    if current_user.tickets < att.tickets && current_user.height < att.min_height
      flash[:alert] = "You do not have enough tickets to ride the #{att.name}. You are not tall enough to ride the #{att.name}"
      redirect_to user_path(current_user)
    elsif current_user.height < att.min_height
      flash[:alert] = "You are not tall enough to ride the #{att.name}"
      redirect_to user_path(current_user)
    elsif current_user.tickets < att.tickets
      flash[:alert] = "You do not have enough tickets to ride the #{att.name}"
      redirect_to user_path(current_user)
    else
      current_user.happiness -= att.nausea_rating
      current_user.nausea -= att.happiness_rating
      current_user.tickets -= att.tickets
      current_user.save
      flash[:alert] = "Thanks for riding the #{att.name}!"
      redirect_to user_path(current_user)
    end
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
