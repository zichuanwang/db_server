require 'singleton'

class db_core
	include Singleton

	attr_accessor :syllablesHashTable
	def initializer
		@syllablesHashTable
	end

end