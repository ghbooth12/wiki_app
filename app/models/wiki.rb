class Wiki < ActiveRecord::Base
  belongs_to :user

  scope :ordered_by_created_at, -> { order('created_at DESC') }
  scope :visible_to, -> (user) do
    if user.present? && (user.admin? || user.premium?)
      all
    else
      where(private: false)
    end
  end

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true
end
