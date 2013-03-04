require 'gmail'

class BackupGmail

	def initialize(settings)
		@settings = settings
		@gmail = Gmail.new(@settings[:username], @settings[:password])		
		#@gmail.peek = true
		dirCheck

	end

	# Directory check 
	def dirCheck
		if !Dir.exists?(@settings[:folder])
			Dir.mkdir(@settings[:folder], 0777)
		end 
	end

	def backup
		emails = @gmail.inbox.emails(:after => @settings[:after]).each do |email|
				uid = email.uid
				data = @gmail.conn.uid_fetch(uid, "X-GM-THRID")
				save_email(email, data[0].attr["X-GM-THRID"])
		end 

	end


	def save_email(email, thread_id)
		filename = "#{@settings[:folder]}/#{thread_id}.txt"
		if !File.exists?(filename)
				f  = File.new(filename, "w")
				f.write(email.body)
				f.close()
			else 	
				f = File.open(filename, "a")  
				f.write("\n-------------------- NEXT EMAIL -----------------------\n")
				f.write(email.body)
				f.close()
		end	

	end


end
