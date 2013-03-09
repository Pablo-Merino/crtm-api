# encoding: utf-8

require 'sinatra'
require 'haml'




configure do
	set :views, "#{File.dirname(__FILE__)}/views"
end

error do
	@e = request.env['sinatra.error']
	puts @e.backtrace.join("\n")
	if ENV['RACK_ENV'] == "production"
		haml :"errors/error", layout: :"errors/error_layout"
	else
		haml :"errors/error_dev", layout: false
	end
end

helpers do

	def partial(page, options={})
		haml page.to_sym, options.merge!(:layout => false)
	end
	
end

get '/' do
	
	haml :index

end
