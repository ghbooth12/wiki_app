class Amount < ActiveRecord::Base
  def self.default
    15_00
  end
end
