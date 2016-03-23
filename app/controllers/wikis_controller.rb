class WikisController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  # GET /wikis
  def index
    @wikis = Wiki.all
  end

  # GET /wikis/1
  def show
    if @wiki.private && !current_user # guest user
      flash[:alert] = "Please sign in to view private wikis."
      redirect_to new_user_session_path
    elsif @wiki.private && current_user && !(current_user.premium? || current_user.admin?)
      flash[:alert] = "Only premium members can view the private wikis."
      redirect_to new_charge_path
    end
  end

  # GET /wikis/new
  def new
    @wiki = Wiki.new
  end

  # GET /wikis/1/edit
  def edit
  end

  # POST /wikis
  def create
    @wiki = current_user.wikis.build(wiki_params)

    if @wiki.save
      redirect_to @wiki, notice: 'Wiki was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /wikis/1
  def update
    if @wiki.update(wiki_params)
      redirect_to @wiki, notice: 'Wiki was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /wikis/1
  def destroy
    if @wiki.destroy
      redirect_to wikis_url, notice: 'Wiki was successfully destroyed.'
    else
      flash[:alert] = "There was an error updating the wiki. Please try again."
      render :index
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def wiki_params
      params.require(:wiki).permit(:title, :body, :private)
    end

    def authorize_user
      unless current_user == @wiki.user || current_user.admin?
        flash[:alert] = "Sorry, you are not authorized."
        redirect_to wikis_path
      end
    end
end
