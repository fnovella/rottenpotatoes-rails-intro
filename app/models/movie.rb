class Movie < ActiveRecord::Base
  def self.get_ratings
    uniq.pluck(:rating)
  end        
end
