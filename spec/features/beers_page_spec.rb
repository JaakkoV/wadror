require 'rails_helper'
include Helpers

describe "Beers' page" do
it "checks that beer without valid name is not saved" do
  visit new_beer_path
  click_button "Create Beer"
  expect(Beer.count).to be(0)
  expect(page).to have_content 'prohibited this beer from being saved'
  expect(page).to have_content "Name can't be blank"
end
end


