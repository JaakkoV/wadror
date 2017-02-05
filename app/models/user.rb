class User < ActiveRecord::Base
  include AverageRating

  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 30 }

  has_many :ratings
end