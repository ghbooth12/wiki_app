class WikisController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]
  before_action :owner_or_admin, only: :destroy

  # GET /wikis
  def index
    @wikis = policy_scope(Wiki)
  end

  # GET /wikis/1
  def show
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
    @wiki.user = current_user
    collabs = Collaborator.make_collaborators(params[:wiki][:collaborators], params[:wiki][:id])

    if @wiki.save && Collaborator.invalid_emails.blank?
      @wiki.collaborators = collabs
      redirect_to @wiki, notice: 'Wiki was successfully created.'
    else
      flash.now[:alert] = "Invalid emails: #{Collaborator.invalid_emails.map {|e| e }.join(', ')}" if Collaborator.invalid_emails.present?
      render :new
    end
  end

  # PATCH/PUT /wikis/1
  def update
    collabs = Collaborator.make_collaborators(params[:wiki][:collaborators], params[:wiki][:id])

    if @wiki.update(wiki_params) && Collaborator.invalid_emails.blank?
      @wiki.collaborators = collabs
      redirect_to @wiki, notice: 'Wiki was successfully updated.'
    else
      flash.now[:alert] = "Invalid emails: #{Collaborator.invalid_emails.map {|e| e }.join(', ')}" if Collaborator.invalid_emails.present?
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
      if @wiki.private && !current_user # guest user
        flash[:alert] = "Please sign in to view wikis."
        redirect_to new_user_session_path
      elsif @wiki.private && current_user &&
        !(current_user == @wiki.user || @wiki.collaborators.pluck(:user_id).include?(current_user.id) || current_user.admin?)
        flash[:alert] = "This wiki's owner or its collaborators ONLY see this view."
        redirect_to wikis_path
      end
    end

    def owner_or_admin
      unless current_user == @wiki.user || current_user.admin?
        flash[:alert] = "Only this wiki's owner and an admin can do that."
        redirect_to wiki_path(@wiki)
      end
    end
end
