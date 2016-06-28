require 'sinatra'
require 'json'
require 'net/http'
require 'erb'
require_relative 'miner.rb'

def get_groups(token)
	uri = URI('https://api.groupme.com/v3/groups')
	params = { :token => token }
	uri.query = URI.encode_www_form(params)
	puts "uri: #{uri}"
	res = Net::HTTP.get_response(uri)
	json_response =  JSON.load(res.body)

	return json_response
end

get '/create_user' do
	@token=params['access_token']
	puts "----------------------"

	@groups= get_groups(@token)
	
	puts "---------------------"
    erb :search
end

post '/search' do 
	search_term = params['search_term']
	group_id = params['group_id']
	token = params['token']
	puts "search_term : #{search_term} group_id #{group_id}"
	mine(token,group_id)
	results = search(search_term, group_id)
	 content_type :json
	 puts "results length: #{results.length}"
	 	# f.puts m_json
  	JSON.generate(results)
end

