class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :delete]
  before_action :move_to_index, only: [:edit, :update, :delete]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to '/'
    else
      render 'new'
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    @prototype.update(prototype_params)
    if @prototype.save
      render 'show'
    else
      render 'edit'
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to '/'
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to action: :index
    end
  end

end