module ApplicationHelper
	
	def return_response(api_return)
		  	respond_to do |format|
		  		format.html { render json: api_return }
		  		format.json { render json: api_return }
		  	end
		end
end
