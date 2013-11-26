class AudioController < ApplicationController
	include ApplicationHelper
	skip_before_filter :verify_authenticity_token

  def create
    @audio = Audio.new(audio_params)
    puts "what"
    puts params[:audio_file]
    puts "the fuck"
    @audio.audio = params[:audio_file]
    if @audio.save
      # Handle a successful save.
      puts @audio.audio.url
      re = ApiReturn.new("000")
   		return_response(re)
   		puts re
    else
      puts "shit"
    end
  end

  def new
  	@audio = Audio.new
  end

  def index
  end

	private 

	def audio_params
    params.require(:audio).permit(:complete_semantic)
  end
end
