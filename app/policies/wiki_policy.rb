class WikiPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user && user.role == 'admin'
        wikis = scope.all
      elsif user && user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private || wiki.user == user || wiki.collaborators.pluck(:user_id).include?(user.id)
            wikis << wiki
          end
        end
      elsif user && user.role == 'standard'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private || wiki.collaborators.pluck(:user_id).include?(user.id)
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private
            wikis << wiki
          end
        end
      end
      wikis
    end
  end
end
