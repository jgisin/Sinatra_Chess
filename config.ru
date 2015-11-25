require './chess'
run Sinatra::Application

get %r{.*images/} do
redirect('images/')
end