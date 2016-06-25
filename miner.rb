require 'net/http'
require 'json'
require 'mongo'
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
def insert_into_db(connection,message_json)	

end

def estab_db_connection()
	config_table= YAML::load_file('search.conf')
	host = config_table["mongodb"]["host"]
	port = config_table["mongodb"]["port"]
	connection_string= host.to_s+":"+port.to_s

	return Mongo::Client.new([ connection_string], :database => 'GroupMeSearch')
end


def collection_exists?(client,name)
	client.collections.each{
		|collection|
			if(collection.name==name)
				return true
			end
	}
	return false
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
	
	mongo_client = estab_db_connection()
	# filename = group_id+'.txt'
	
	if(not(collection_exists?(mongo_client, group_id)))
		# f = File.open(filename, "w")
		mongo_client[group_id.to_s].create()
		messages.each{|m|
			m_json = JSON.generate(m) 
			# f.puts m_json
		puts " "
			puts m_json
		puts " "
			mongo_client[group_id.to_s].insert_one(m)
		}

	end
end
