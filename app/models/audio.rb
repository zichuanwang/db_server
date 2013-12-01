class Audio < ActiveRecord::Base
	has_attached_file :audio, :default_url => "/audio/:style/missing.png"

	validates_presence_of :complete_semantic, :segmented_semantic
end
