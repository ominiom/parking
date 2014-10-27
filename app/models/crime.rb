class Crime < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude

  attr_accessor :score

  scope :scored, -> {
    select('(distance * 2) AS score')
  }
end
