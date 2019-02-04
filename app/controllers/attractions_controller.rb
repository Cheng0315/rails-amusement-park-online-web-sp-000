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
    @att = Attraction.find(params[:id])
    if current_user.admin
      @att.update(attraction_params)
      redirect_to attraction_path(@att)
    else
      redirect_to root
    end

  end

  private

  def attraction_params
    params.require(:attraction).permit(:name, :happiness_rating, :nausea_rating, :tickets, :min_height)
  end
end
