module AverageRating
  extend ActiveSupport::Concern

  def average_rating
    sum = self.ratings.inject(0){ |sum, rating| sum + rating.score.to_f }
    average = (sum / ratings.size).round 2
  end
end