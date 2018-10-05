class ClubsController < ApplicationController

  before_action :require_login, except: [:index]
  before_action :require_role, only: [:show]
  before_action :require_ownership, only: [:edit, :update]

  def index
    @clubs = Club.all
  end

  def show
    # if session[:user_id] #logged in
    #   @club = Club.find(params[:id])
    #   render :show
    # else #not logged in
    #   flash[:alert] = ["You must login first"]
    #   redirect_to new_session_path
    # end

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
    if @club && @club.update(name: params[:club][:name], description: params[:club][:description], user: current_user)
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :edit
    end
  end

  private

  def require_login
    if !session[:user_id]
      flash[:alert] = ["You must login first"]
      redirect_to new_session_path
    end
  end

  def require_ownership
    @club = Club.find(params[:id])
    if current_user != @club.user
      flash[:alert] = ["You must be the owner of this club to edit it"]
      redirect_to root_path
    end
  end

  def require_role
    if Club.disallowed_roles.include?(current_user.role)
      flash[:alert] = ["#{current_user.role.capitalize}s are not allowed into clubs"]
      redirect_to root_path
    end
  end

end
