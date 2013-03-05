require './backup_class.rb'


# Application settings
settings = Hash.new
settings[:username] = 'xxx@gmail.com'		 	# Gmail username 
settings[:password] = 'your password'				# Gmail password
settings[:folder] 	= 'emails_backup'					# Folder to store emails
settings[:after]	= Date.today - 30					# Before this date

gmail = BackupGmail.new(settings)

gmail.backup # Starts the back up process


