class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true

  has_many :ratings
end