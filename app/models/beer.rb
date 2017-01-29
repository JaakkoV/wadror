class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings
  include AverageRating

  def to_s
    "#{self.name}, #{self.brewery.name}"
  end
end