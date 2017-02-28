class Amount < ActiveRecord::Base
  def self.default
    1_00
  end
end
