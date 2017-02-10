require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "saves beer with a name and style to the database" do
    beer = Beer.create name: "testiOlut", style: "testiStyle"
    expect(beer).to be_valid
  end

  it "does not save beer without a name to the database" do
    beer = Beer.create style: "testiStyle"
    expect(beer).not_to be_valid
  end

  it "does not save beer without a style to the database" do
    beer = Beer.create name: "testiOlut"
    expect(beer).not_to be_valid
  end
end
