require './chess'
run Sinatra::Application

use Rack::Static, :urls => ['/images'], :root => 'public'