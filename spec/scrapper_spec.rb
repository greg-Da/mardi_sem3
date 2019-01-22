require_relative '../lib/app/scrappeur.rb'
describe "cherche les urls des pages des villes" do
  it "trouver l'url des 185 villes du Val d'Oise" do
    expect(get_townhall_urls[1].size).to eq(185)
  end
end

describe "cherche les emails des villes" do
  it "trouver l'email d'une ville du Val d'Oise" do
    expect(get_townhall_email("http://annuaire-des-mairies.com/95/arnouville-les-gonesse.html")).to eq("webmaster@villedarnouville.com")
  end
end