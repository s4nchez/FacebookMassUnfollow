require 'yaml'
require 'watir'

config_file = "#{ENV['HOME']}/.facebook.yml"

unless File.exists?(config_file)
	puts "Missing ~/.facebook.yml"
	exit 1
end

config = YAML.load_file(config_file)

elements = { true => "Following", false => "Follow" }
follow = config['follow_all']

puts "Follow friends? #{follow}"

puts "Logging in as #{config['email']}..."

browser = Watir::Browser.new
browser = Watir::Browser.start("https://www.facebook.com")

browser.text_field(:name, "email").value = config['email']
browser.text_field(:name, "pass").value = config['password']

browser.form(:id, "login_form").submit

puts "Login ok. Retrieving friend list..."

browser.goto('https://developers.facebook.com/tools/debug/accesstoken/')
token = browser.text_field(:name, "q").value

graph_response = Net::HTTP.get(URI("https://graph.facebook.com/me/friends?access_token=#{token}&fields=id,name"))
friends_list = JSON.parse graph_response

friends_list["data"].each_with_index do |friend, index|
	print "[#{index+1}/#{friends_list["data"].count}] #{friend['name']}... "
	friend_id = friend["id"] 
	browser.goto("https://www.facebook.com/#{friend_id}")	
	
	if follow == browser.span(:text, "Following").visible?
		print "[nothing to change]"
	else	
		browser.span(:text, elements[!follow]).fire_event(:click)
		browser.span(:text, elements[follow]).wait_until_present
		print "[following=#{follow}]"
	end
	print "\n"
end