#!/bin/env ruby
# encoding => utf-8

require "rubypython"

#RubyPython.start(:python_exe => "python2.7") # start the Python interpreter

module TextSegmentation	
	
	@@jieba = RubyPython.import('jieba.posseg')
	def self.text_segment(sentence)
		cutted = @@jieba.my_cut(sentence).encode('utf-8').rubify.force_encoding('utf-8')

		result = {}
		cutted.split.each do |pair|
			split_pair = pair.split(',')
			word = split_pair[0]
			if word.match(/[\u3002\uff1b\uff0c\uff1a\u201c\u201d\uff08\uff09\u3001\uff1f\u300a\u300b,\.]/) then next end
			flag = split_pair[1]
			result[word] = flag
		end
		result
	end
end

#result = TextSegmentation.text_segment("我爱北京天安门。")