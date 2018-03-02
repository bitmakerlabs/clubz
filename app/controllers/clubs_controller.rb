class ClubsController < ApplicationController
  before_action :ensure_login, except: [:index]
  before_action :ensure_role, only: [:show]
  before_action :ensure_ownership, only: [:edit, :update]

  def index
    @clubs = Club.all
  end

  def show
    @club = Club.find(params[:id])
  end

  def new
    @club = Club.new
  end

  def create
    @club = Club.new(
      name: params[:club][:name],
      description: params[:club][:description],
      user: current_user
    )

    if @club.save
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    @club = Club.find(params[:id])

    if @club && @club.update(name: params[:club][:name], description: params[:club][:description], user: current_user)
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :edit
    end
  end

  private

  def ensure_ownership
    @club = Club.find(params[:id])

    unless @club.user_id == session[:user_id]
      flash[:alert] = ["This club doesn't belong to you"]
      redirect_to root_path
    end
  end

  def ensure_login
    unless session[:user_id]
      flash[:alert] = ["Please login first"]
      redirect_to new_session_path
    end
  end

  def ensure_role
    # unless current_user.role == "wizard" || current_user.role == "hobbit"
    unless ["wizard", "hobbit"].include?(current_user.role)
      flash[:alert] = ["We don't allow #{current_user.role}"]
      redirect_to root_path
    end
  end

end
