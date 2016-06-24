require 'sinatra'
require 'json'
require 'net/http'
require 'erb'
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
	token=params['access_token']
	puts "----------------------"

	@groups= get_groups(token)
	
	puts "---------------------"
    erb :search
end

