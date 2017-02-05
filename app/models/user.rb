class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username,
            uniqueness: true,
            length: { minimum: 3, maximum: 30 }

  validates :password,
            length: { minimum: 4},
            format: { with: /.*[A-Z].*\d|.*\d.*[A-Z]/x }

  include AverageRating
  has_secure_password
end