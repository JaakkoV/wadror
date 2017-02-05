class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  include AverageRating

  validates :name, presence: true

  def to_s
    return "#{name}, #{brewery.name}"
  end
end