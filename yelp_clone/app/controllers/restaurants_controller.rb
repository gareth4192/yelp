class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]
  before_action :check_author, :only => [:edit, :update, :destroy]

  def check_author
    if current_user.id != Restaurant.find(params[:id]).user_id
      flash[:notice] = 'nope'
      redirect_to '/restaurants' and return
    end
  end

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def restaurant_params
    new_params = params.require(:restaurant).permit(:name, :image)
    new_params[:user_id] = current_user.id
    new_params
  end

  def create
    @restaurant = Restaurant.create(restaurant_params)
    if @restaurant.save
      redirect_to '/restaurants'
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    flash[:notice] = 'Restaurant deleted successfully'
    redirect_to '/restaurants'
  end


end
