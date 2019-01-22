require 'open-uri'

class Townhall
	attr_reader :hash_townhall

	def get_townhall_email(townhall_url)
		page = Nokogiri::HTML(open(townhall_url))   
		page.xpath('//div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
	end

	def get_townhall_urls
		town_name =[]
		town_url = []
		page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))   
		page.xpath('//a[@class="lientxt"]').each do |link|
		  town_name <<  link.text
		  town_url << "http://annuaire-des-mairies.com" + link["href"][1..-1]
		end
		return [town_url, town_name]
	end


	def initialize
		@hash_townhall = {}
		townhall_info = get_townhall_urls
		url_list = townhall_info[0]
		name_list = townhall_info[1]
		url_list.each_with_index do |townhall_url,i|
			@hash_townhall[name_list[i]] = get_townhall_email(townhall_url)
		end
=begin
#si le serveur est mort
		File.open("db/copie.JSON").each do |line|
			@hash_townhall = JSON.parse(line)
		end
=end

	end

	def to_s
		puts @hash_townhall
	end

	def save_as_JSON
		#ouvrir le .JSON
		File.open("db/email.JSON","w+") do |line|
			#ecrit dans le JSON
		  line.write(@hash_townhall.to_json)
		end
	end

	def save_as_csv
		array_townhall = []
		#rentre les keys et les values dans un array
		@hash_townhall.each do |name_town,email_town| 
			array_townhall << [name_town, email_town]
		end

		CSV.open("db/email.csv","w+") do |csv|
			#index
			csv << ["city","email"]
			#rentre les valeurs en csv
		  array_townhall.each do |a|
		  	csv << a
		  end
		end
	end

	def save_as_spreadsheet
		array_townhall = []
		#transforme le hash en array
		@hash_townhall.each do |name_town,email_town| 
			array_townhall << [name_town, email_town]
		end

		#trouve la worksheet
		session = GoogleDrive::Session.from_config(".env")
		spread_sheet = session.spreadsheet_by_title("mail")
		ws = spread_sheet.worksheets[0]

		#rentre les donnees 
		array_townhall.each_with_index do |townhall,i|
			ws[i+1,1] = townhall[0]
			ws[i+1,2] = townhall[1]
		end	
		ws.save
	end
end