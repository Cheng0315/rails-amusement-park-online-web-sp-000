class AttractionsController < ApplicationController

  def index
    @att = Attraction.all
    @user = current_user
  end

  def new
    @att = Attraction.new
  end

  def create
    @att = Attraction.new(attraction_params)

    if current_user.admin
      @att.save
      redirect_to attraction_path(@att)
    else
      redirect_to new_attraction_path
    end
  end

  def show
    @att = Attraction.find(params[:id])
    @user = current_user
  end

  def edit
    @att = Attraction.find(params[:id])
  end

  def update
    att = Attraction.find(params[:id])

    if current_user.admin
      att.update(attraction_params)
      redirect_to attraction_path
    else
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
  end

  private

  def attraction_params
    params.require(:attraction).permit(:name, :happiness_rating, :nausea_rating, :tickets, :min_height)
  end
end
