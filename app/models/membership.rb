class Membership < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :beer_club, dependent: :destroy

  def to_s
    return "#{beer_club.name}"
  end
end