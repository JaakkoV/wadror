require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "lists multiple locations at the page, all that API returns" do
    allow(BeermappingApi).to receive(:places_in).with("hellsinki").and_return(
        [Place.new( name:"pirunBaari", id: 666 ), Place.new( name: "satansBeerHouse", id: 6 )]
    )

    visit places_path
    fill_in('city', with: 'hellsinki')
    click_button "Search"

    expect(page).to have_content "pirunBaari"
    expect(page).to have_content "satansBeerHouse"
  end

  it
end