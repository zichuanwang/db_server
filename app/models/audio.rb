class Audio < ActiveRecord::Base
	has_attached_file :audio, :default_url => "/audio/:style/missing.png"
end
