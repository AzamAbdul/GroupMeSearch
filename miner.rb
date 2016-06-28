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
	
	
	mongo_client = estab_db_connection()
	# filename = group_id+'.txt'
	
	if(not(collection_exists?(mongo_client, group_id)))
		# f = File.open(filename, "w")
		res = page_through(group_id, tok)
		messages = []
		messages_exist = true
		while(res.is_a?(Net::HTTPSuccess) and messages_exist)
			responseBody = JSON.load(res.body)
			messages_exist = responseBody["response"]["messages"]!=nil
			if(messages_exist) 
				curr_page=  responseBody["response"]["messages"]
				curr_page.each{|m| messages<< m}

				res = page_through(  group_id,tok,messages[messages.length-1]["id"])
			end

		end
		
		collection = mongo_client[group_id.to_s]
		collection.create()

		messages.each{|m|
			m_json = JSON.generate(m) 
			# f.puts m_json
			puts " "
			puts m_json
			puts " "
			mongo_client[group_id.to_s].insert_one(m)
		}
		collection.indexes.create_one({"text"=>"text","content"=>"text"})
	end
end

def search (term,group_id)
	client = estab_db_connection()

	matching_docs=  client[group_id.to_s].find({"$text"=> {"$search"=> term}}, {"score"=> {"$meta"=> "textScore"}})
	matchin_docs = matching_docs.sort( {score: {"$meta": 'textScore'}})
	results = []

	matching_docs.each{
		|message|
		puts message
		return_hash = Hash.new
		return_hash["name"] =message["name"]
		return_hash["avatar"] = message["avatar_url"]
		return_hash["text"] = message["text"]
		return_hash["time"] =message["created_at"]
		results << return_hash
	}
	return results

end
