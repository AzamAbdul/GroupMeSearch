require 'net/http'
require 'json'

def page_through(group_id, tok,before_id=nil)
	url = "https://api.groupme.com/v3/groups/#{group_id}/messages"
	uri = URI(url)
	params = nil
	if(before_id !=nil)
		params = { :token => tok ,:limit => 100, :before_id => before_id}
	else
		params = { :token => tok ,:limit => 100}
	end

	
	uri.query = URI.encode_www_form(params)
	puts uri
	res = Net::HTTP.get_response(uri)
	return res
end

def mine(tok, group_id)
	res = page_through(group_id, tok)
	messages = []
	while(res.is_a?(Net::HTTPSuccess))
		responseBody = JSON.load(res.body)
		curr_page=  responseBody["response"]["messages"]
		curr_page.each{|m| messages<< m}

		res = page_through(  group_id,tok,messages[messages.length-1]["id"])
	end
	filename = group_id+'.txt'
	if(!File.file?(filename))
		f = File.open(filename, "w")
		messages.each{|m| f.puts JSON.generate(m)}
	end
end