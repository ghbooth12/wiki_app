class UserPageController < ApplicationController
  def view_user_page
    @user = User.find(params[:user])
    @public_wikis = Wiki.where(user: @user, private: false)
    @private_wikis = Wiki.where(user: @user, private: true)
    @collaborated_wikis = Wiki.where(id: Collaborator.where(user: @user).map(&:wiki_id))
  end
end
