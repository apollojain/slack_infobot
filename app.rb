require 'sinatra'
require 'httparty'
require 'json'

post '/gateway' do
	message = params[:text].gsub(params[:trigger_word], '').strip

	action, query = get_qction_query message
	case action
		when 'wiki'
		  # resp = get_wiki query
		  # respond_message resp
		  respond_message "hello"
	end
end

def get_action_query message
	message_arr = message.split(' ')
	action, query = message[0].strip.downcase, message[1..-1].join(' ')
	return [action, query]
end 

def respond_message message
	content_type :json
	{:text => message}.to_json  
end

def get_wiki search_term
	search_term = search_term.split.map(&:capitalize).join(' ')
	hit_url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=#{search_term}"
	resp = HTTParty.get(hit_url)
	key = resp["query"]["pages"].keys[0]
	if key == "-1"
		return "We are sorry. There are no results for this particular query."
	else 
		return resp["query"]["pages"][key]["extract"]
	end
end



