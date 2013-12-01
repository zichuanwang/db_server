class AudioController < ApplicationController
	include ApplicationHelper
	skip_before_filter :verify_authenticity_token

	def self.init_syllables_hashtable
		result =  {}
		puts 'init_syllables_hashtable'
		Audio.all.each do |audio|
			audio.segmented_semantic.split.each do |keyword|
				puts keyword
				result[keyword] = audio.id
			end
		end
		result
	end

	@@syllables_hashtable = AudioController.init_syllables_hashtable

  def create
    @audio = Audio.new(audio_params)
    @audio.segmented_semantic = @audio.complete_semantic
    @audio.audio = params[:audio_file]
    if @audio.save
      # Handle a successful save.
      puts @audio.audio.url
      re = ApiReturn.new("000")
   		return_response(re)
   		puts re
    else
    	puts @audio.errors.full_messages
    	render text: @audio.errors.full_messages
    end
  end

  def index
  	audios = Audio.all
  	render json: audios
	end

  def show
  	audio = Audio.find(params[:id])
  	render json: audio
  end

	private 

	def audio_params
    puts params.require(:audio).permit(:complete_semantic)
    params.require(:audio).permit(:complete_semantic)
  end
end
