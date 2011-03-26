require 'goliath'
require 'goliath/plugins/latency'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
require 'soulmate'

class SoulmateWorker < Goliath::API
    	include Soulmate::Helpers

	def response(env)
Soulmate.redis = redis
		logger.info env.params.inspect
      		limit = (env.params['limit'] || 5).to_i
      		types = env.params['types[]'].to_s.split(',').map { |t| normalize(t) }
      		term  = env.params['term']
      
      		results = {}
      		types.each do |type|
      			matcher = Soulmate::Matcher.new(type)
      			results[type] = matcher.matches_for_term(term, :limit => limit)
      		end
      
      		[200, {}, JSON.pretty_generate({
      			:term    => params['term'],
        		:results => results
      			})]
	end
end
  class Server < Goliath::API
	#use ::Rack::Reloader, 0 if Goliath.dev?

   
    use Goliath::Rack::Params             # parse & merge query and body parameters
    use Goliath::Rack::DefaultMimeType    # cleanup accepted media types
    #use Goliath::Rack::Render             # auto-negotiate response format
 
    
      #raise Sinatra::NotFound unless (params[:term] and params[:types] and params[:types].is_a?(Array))
     
    map 'http://ec2-75-101-212-134.compute-1.amazonaws.com/favicon.ico' do 
	run Proc.new {|env| [404, {}, 'no favicon'] }
    end
    map 'http://ec2-75-101-212-134.compute-1.amazonaws.com/search' do 
	run SoulmateWorker.new
    end
    
  end
