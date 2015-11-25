require 'sinatra'
#require 'byebug'
require_relative 'game'

	move_piece = nil
		g = Game.new
		current_turn = "W"

enable :sessions


get '/' do
	#if g.checkmate?(current_turn) == true
		#redirect("/final")
	#end
	session['b'] = g.b
	query = params.map{|key, value| "#{key}=#{value}"}.join("&")
	if (params["Row"] != nil) && (params["Column"] != nil) &&
		session['b'].find_piece(params["Row"].to_i, params["Column"].to_i).color == current_turn
		session['c'] = session['b'].find_piece(params["Row"].to_i, params["Column"].to_i)
		redirect("move?#{query}")
	elsif (params["Row"] != nil) && (params["Column"] != nil) &&
		session['b'].find_piece(params["Row"].to_i, params["Column"].to_i).color != current_turn
		redirect("/")
	end

	def piece?(piece)

		if piece.is_a? Piece
			return "/?Row=#{piece.row}&Column=#{piece.column}"
		else
			return "/"
		end
	end



	erb :index, :locals => {:g => g, :selected_piece => session['c'], :current_turn => current_turn}
end

get '/move' do


	session['b'] = g.b
	query = params.map{|key, value| "#{key}=#{value}"}.join("&")



if params["Row"] && params["Column"] 
	session['p'] = session['b'].find_piece(params["Row"].to_i, params["Column"].to_i)
end




if params["End_Row"] && params["End_Column"]
	if (session['b'].find_piece(params["End_Row"].to_i, params["End_Column"].to_i).is_a? Piece)
		session['t'] = session['b'].find_piece(params["End_Row"].to_i, params["End_Column"].to_i)
	else
		session['t'] = "_"
	end
end


	if (params["End_Row"] != nil) && (params["End_Column"] != nil) #&& 
		#g.move_piece(g.b.board[session['c'].row][0][session['c'].column], session['b'], params["End_Row"].to_i, params["End_Column"].to_i, current_turn)
		





		if g.check?(session['b'], current_turn) == true
			if (g.move_piece(g.b.board[session['c'].row][0][session['c'].column], session['b'], params["End_Row"].to_i, params["End_Column"].to_i, current_turn)) &&
				(g.check?(session['b'], current_turn) == false)
				current_turn = g.turn(current_turn)
			else
				print "You are still in check."
				g.b.board[session['p'].row][0][session['p'].column] = session['b'].board[params["End_Row"].to_i][0][params["End_Column"].to_i]
				#byebug
				g.b.board[params["End_Row"].to_i][0][params["End_Column"].to_i].row = session['p'].row
				g.b.board[params["End_Row"].to_i][0][params["End_Column"].to_i].column =  session['p'].column
				g.b.board[params["End_Row"].to_i][0][params["End_Column"].to_i] = session['t']
			end
		elsif (g.check?(session['b'], current_turn) == false) &&
		   (g.move_piece(g.b.board[session['c'].row][0][session['c'].column], session['b'], params["End_Row"].to_i, params["End_Column"].to_i, current_turn))
		   if g.check?(session['b'], current_turn) == true
		   		print "This will put you in check."
				g.b.board[session['p'].row][0][session['p'].column] = session['b'].board[params["End_Row"].to_i][0][params["End_Column"].to_i]
				#byebug
				g.b.board[params["End_Row"].to_i][0][params["End_Column"].to_i].row = session['p'].row
				g.b.board[params["End_Row"].to_i][0][params["End_Column"].to_i].column =  session['p'].column
				g.b.board[params["End_Row"].to_i][0][params["End_Column"].to_i] = session['t']
			else
			current_turn = g.turn(current_turn)
			end
		end








		#current_turn = g.turn(current_turn)
		redirect("/")
	elsif (params["End_Row"] != nil) && (params["End_Column"] != nil) && 
		g.move_piece(session['c'], session['b'], params["End_Row"].to_i, params["End_Column"].to_i, "W") == false
		redirect("move?Row=#{session['c'].row}&Column=#{session['c'].column}")
	end

	def selector(selected_piece, piece)
		if (piece.is_a? Piece) && (selected_piece.column == piece.column) &&
			(selected_piece.row == piece.row)
			return "Active"
		else
			return "Inactive"
		end
	end



	erb :move, :locals => {:g => g, :selected_piece => session['c'], :current_turn => current_turn}
end

get '/final' do

	erb :final, :locals => {:g => g, :selected_piece => session['c'], :current_turn => current_turn}

end

get '/new' do

		g = nil
		session['b'] = nil
		session['c'] = nil
		g = Game.new
		session['b'] = g.b
		redirect("/")

	erb :new, :locals => {:g => g, :selected_piece => session['c'], :current_turn => current_turn}
end








