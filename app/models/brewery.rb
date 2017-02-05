class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { less_than_or_equal_to: Proc.new { Time.now.year }}, numericality: { greater_than_or_equal_to: 1042}

  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2017
    puts "changed year to #{year}"
  end
end
