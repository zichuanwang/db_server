#!/bin/env ruby
# encoding => utf-8

require "rubypython"

#RubyPython.start(:python_exe => "python2.7") # start the Python interpreter


module TextSegmentation	

	@@jieba = RubyPython.import('jieba')
	def self.text_segment(sentence)
		result = @@jieba.my_cut(sentence).encode('utf-8').rubify.force_encoding('utf-8')
		result.gsub(/[\u3002\uff1b\uff0c\uff1a\u201c\u201d\uff08\uff09\u3001\uff1f\u300a\u300b,\.]/, '')
	end
end