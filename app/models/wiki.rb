class Wiki < ActiveRecord::Base
  belongs_to :user

  scope :ordered_by_created_at, -> { order('created_at DESC') }
end
