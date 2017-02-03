class User < ActiveRecord::Base
  include AverageRating

  validates :username, uniqueness: true

  has_many :ratings
end