class AudioController < ApplicationController
	include ApplicationHelper
  include TextSegmentation
  include SemanticProcessing
  include SyllablesProcessing
	skip_before_filter :verify_authenticity_token

  @@syllables_hashtable = {}

	def self.init_syllables_hashtable
		puts 'init_syllables_hashtable'

    if !ActiveRecord::Base.connection.table_exists? 'audios' then return end
    puts Audio.all

		Audio.all.each do |audio|
			audio.segmented_semantic.split.each do |keyword|
				puts keyword
        if keyword == 'null' then next end
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
    if !key_seg.empty?
      @audio.segmented_semantic = key_seg
    else
      @audio.segmented_semantic = 'null'
    end
    @audio.audio = params[:audio_file]
    if @audio.save
      # Handle a successful save.
      puts @audio.audio.url
      re = ApiReturn.new("000")
   		return_response(re)
   		puts re

      @audio.segmented_semantic.split.each do |keyword|
        puts keyword
        if keyword == 'null' then next end
        hash = SyllablesProcessing.calculate_noraml_han_word_hash(keyword)
        puts hash
        if @@syllables_hashtable.has_key?(hash)
          @@syllables_hashtable[hash] << @audio.id
        else
          @@syllables_hashtable[hash] = [@audio.id]
        end
      end
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
    # first layer search
    keywords = params[:keywords]
    first_result = []
    raw_seg = TextSegmentation.text_segment(keywords)
    key_seg = SemanticProcessing.semantic_process(raw_seg)
    key_seg.split.each do |keyword|
      hash = SyllablesProcessing.calculate_noraml_han_word_hash(keyword)
      if first_result.empty?
        first_result |= @@syllables_hashtable[hash]
      else
        first_result &= @@syllables_hashtable[hash]
      end
    end

    puts "first_result"
    puts first_result

    audios = []
    first_result.each do |audio_id|
      audios << Audio.find(audio_id)
    end

    # second layer search 
    puts "audios"
    puts audios

    audios_weight = {}
    search_tone_hashs = []
    key_seg.split.each do |keyword|
      search_tone_hashs << SyllablesProcessing.calculate_tone_han_word_hash(keyword)
    end

    puts "search_tone_hashs"
    puts search_tone_hashs

    audios.each do |audio|
      audios_weight[audio] = 0
      audio.segmented_semantic.split.each do |seg_key|
        tone_hash = SyllablesProcessing.calculate_tone_han_word_hash(seg_key)
        if search_tone_hashs.include?(tone_hash) then audios_weight[audio] += 10 end
      end
    end

    puts "audios_weight"
    puts audios_weight

    second_result = []
    audios_weight.sort_by{|audio, weight| weight}[0..[5, audios_weight.length].min].each do |audio_weight_pair|
      second_result << audio_weight_pair[0]
    end

    render json: second_result
  end

	private 

  def syllables_hash_index_compare

  end

	def audio_params
    params.require(:audio).permit(:complete_semantic)
  end
end