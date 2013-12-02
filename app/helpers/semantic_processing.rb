#!/bin/env ruby
# encoding => utf-8

module SemanticProcessing
	def self.semantic_process(word_pair_dict)
		result = ''
		word_pair_dict.each_pair do |word, flag|
			if flag[0] == 'n' || flag[0] == 'v'
				result << word << ' '
			end
		end
		result
	end
end