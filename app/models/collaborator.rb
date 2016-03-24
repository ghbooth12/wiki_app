class Collaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  def self.make_collaborators(string, wiki_id)
    return Collaborator.none if string.empty?
    collabs = []
    @invalids = []

    string.split(",").map do |collaborator|
      if user = User.find_by(email: collaborator.strip)
        collabs << Collaborator.find_or_create_by(user_id: user.id, wiki_id: wiki_id)
      else
        @invalids << collaborator.strip
      end
    end
    collabs
  end

  def self.invalid_emails
    @invalids
  end
end
