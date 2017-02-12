require 'rails_helper'
include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "create ratings" do
    before :each do
      FactoryGirl.create :rating, user: user, beer: beer1, score:1
      FactoryGirl.create :rating, user: user, beer: beer2, score:2
      FactoryGirl.create :rating, user: user, beer: beer2, score:22
    end

    it "match given ratings count" do
      visit ratings_path
      expect(page).to have_content "Number of ratings 3"
      expect(page).to have_content "iso 3 1"
      expect(page).to have_content "Karhu 2"
      expect(page).to have_content "Karhu 22"
    end

    it "show all on rater's page" do
      reitteri = FactoryGirl.create :user, username: "reitteri"
      FactoryGirl.create :rating, user: reitteri, beer: beer1, score:11

      visit user_path(user)
      expect(page).to have_content "iso 3 1"
      expect(page).to have_content "Karhu 2"
      expect(page).to have_content "Karhu 22"
      expect(page).not_to have_content "iso 3 11"
    end

    it "if rater deletes it's rating, it's deleted from the db" do
      visit user_path(user)
      expect{
        page.all('a', text:'delete')[1].click
      }.to change{Rating.count}.by(-1)
    end
  end
end