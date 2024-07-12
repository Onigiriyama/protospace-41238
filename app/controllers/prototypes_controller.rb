class PrototypesController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update]

  def index
    @user_name = current_user.name if user_signed_in?
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    @prototype.user = current_user
  
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @prototype_user = @prototype.user
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      logger.debug "Prototype update failed: #{@prototype.errors.full_messages.join(", ")}"
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private

  def authorize_user!
    @prototype = Prototype.find(params[:id])
    redirect_to root_path unless @prototype.user == current_user
  end

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image)
  end

end