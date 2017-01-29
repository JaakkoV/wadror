class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def avg
    ratings = Rating.where beer_id:self.id
    ratings.average(:score).to_f.round 2
  end

  def to_s
    "#{self.name}, #{self.brewery.name}"
  end
end