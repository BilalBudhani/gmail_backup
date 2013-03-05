require 'gmail'

module Net
  class IMAP
    class ResponseParser 
      def msg_att
        match(T_LPAR)
        attr = {}
        while true
          token = lookahead
          case token.symbol
          when T_RPAR
            shift_token
            break
          when T_SPACE
            shift_token
            token = lookahead
          end
          case token.value
          when /\A(?:ENVELOPE)\z/ni
            name, val = envelope_data
          when /\A(?:FLAGS)\z/ni
            name, val = flags_data
          when /\A(?:INTERNALDATE)\z/ni
            name, val = internaldate_data
          when /\A(?:RFC822(?:\.HEADER|\.TEXT)?)\z/ni
            name, val = rfc822_text
          when /\A(?:RFC822\.SIZE)\z/ni
            name, val = rfc822_size
          when /\A(?:BODY(?:STRUCTURE)?)\z/ni
            name, val = body_data
          when /\A(?:UID)\z/ni
            name, val = uid_data

          when /\A(?:X-GM-MSGID)\z/ni  # Added X-GM-MSGID extension
            name, val = uid_data
          when /\A(?:X-GM-THRID)\z/ni  # Added X-GM-THRID extension
            name, val = uid_data

          else
            parse_error("unknown attribute `%s'", token.value)
          end
          attr[name] = val
        end
        return attr
      end

    end
  end
end

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
