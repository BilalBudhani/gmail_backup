require 'ap'
require './backup_class.rb'


# Application settings
settings = Hash.new
settings[:username] = 'bilalbudhani@gmail.com'		 	# Gmail username 
settings[:password] = 'qobgnbeljdbvnkuu'				# Gmail password
settings[:folder] 	= 'emails_backup'					# Folder to store emails
settings[:after]	= Date.today - 30					# Before this date

gmail = BackupGmail.new(settings)

gmail.backup # Starts the back up process


