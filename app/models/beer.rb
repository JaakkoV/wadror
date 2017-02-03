class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average
    ratings.map{ |r| r.score }.sum / ratings.count.to_f unless ratings.empty?
  end
  def to_s
    "#{self.name}, #{self.brewery.name}"
  end

end