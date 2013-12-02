class AudioController < ApplicationController
	include ApplicationHelper
  include TextSegmentation
  include SemanticProcessing
  include SyllablesProcessing
	skip_before_filter :verify_authenticity_token

  @@syllables_hashtable = {}

	def self.init_syllables_hashtable
		puts 'init_syllables_hashtable'
		Audio.all.each do |audio|
			audio.segmented_semantic.split.each do |keyword|
				puts keyword
        hash = SyllablesProcessing.calculate_noraml_han_word_hash(keyword)
        puts hash
        if @@syllables_hashtable.has_key?(hash)
          @@syllables_hashtable[hash] << audio.id
        else
          @@syllables_hashtable[hash] = [audio.id]
        end
			end
		end
	end

  def create
    @audio = Audio.new(audio_params)
    raw_seg = TextSegmentation.text_segment(@audio.complete_semantic)
    key_seg = SemanticProcessing.semantic_process(raw_seg)
    @audio.segmented_semantic = key_seg
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

  def search
    keywords = params[:keywords]
    result = []
    raw_seg = TextSegmentation.text_segment(keywords)
    key_seg = SemanticProcessing.semantic_process(raw_seg)
    key_seg.split.each do |keyword|
      hash = SyllablesProcessing.calculate_noraml_han_word_hash(keyword)
      if result.empty?
        result |= @@syllables_hashtable[hash]
      else
        result &= @@syllables_hashtable[hash]
      end
    end
    render json: result
  end

	private 

  def syllables_hash_index_compare

  end

	def audio_params
    params.require(:audio).permit(:complete_semantic)
  end
end