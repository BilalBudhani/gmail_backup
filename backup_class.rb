require 'gmail'

class BackupGmail

	def initialize(settings)
		@settings = settings
		@gmail = Gmail.new(@settings[:username], @settings[:password])	
		dirCheck

	end

	# Directory check 
	def dirCheck
		if !Dir.exists?(@settings[:folder])
			Dir.mkdir(@settings[:folder], 0777)
		end 
	end

	def backup
		@gmail.inbox.emails(:after => @settings[:after]).each do |email|
			save_email(email)
		end
	end


	def save_email(email)
		f = File.new("#{@settings[:folder]}/#{email.uid}.txt", "w")
		f.write(email.body)
		f.close
	end

end