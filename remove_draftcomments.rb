# remove_draftcomments.rb
# Written by Wayne Brissette
# Version: v1.0
# Date: 2013-03-18
#
# Description:
# Removes all draft-comments put into DITA documents.
#
# Usage:
# from the command prompt in Windows (or terminal in linux/Unix) type:
# Ruby remove_draftcomments.rb <directory path>
#
# Note: You may have to use a path in front of remove_draftcomments.rb depending on where
# items are located on your computer.

require 'optparse'         # built-into Ruby, no gem needed

optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: ruby remove_draftcomments.rb <directory path>\n\nHint: You can drag and drop your folder from the GUI to the command-line for the full path."

  # Define the options, and what they do


   opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    puts "\nUsage: ruby remove_draftcomments.rb <directory path>\n\nHint: You can drag and drop your folder from the GUI to the command-line for the full path."
    exit
  end
end

optparse.parse!



def remove_draft(contents)
  contents.gsub!(/<draft-comment.+?<\/draft-comment>/, "")
  @changed = TRUE
end


#Path to DITAFile
@input_dirname = ARGV[0]
if   @input_dirname == ARGV[0].nil?
puts "\nUsage: ruby remove_draftcomments.rb <directory path>\n\nHint: You can drag and drop your folder from the GUI to the command-line for the full path."
exit
end

puts @input_dirname

@output_dirname = ARGV[1]
if ARGV[1].nil?
  @output_dirname = "#{@input_dirname}/changed_files"
  Dir::mkdir(@output_dirname) unless File.exists?(@output_dirname)
else
 Dir::mkdir(@output_dirname) unless File.exists?(@output_dirname)
end

@filelist = Dir.entries(@input_dirname).join(' ')
@filelist = @filelist.split(' ').grep(/\.xml/)      # only dita.xml files for now

puts @filelist

@filelist.each do |a_ditafile|
  @changed = FALSE
  puts "Opening File: #{a_ditafile}\n"
  f = File.open("#{@input_dirname}/#{a_ditafile}", 'r')
  raw_contents = f.read
  f.close


  if raw_contents.match(/<draft/)
    remove_draft(raw_contents)
  end
  myfileName = "#{@output_dirname}/#{a_ditafile}"

      File.open(myfileName, 'w') {|f| f.write(raw_contents) } if @changed == TRUE
  puts "\n#{a_ditafile} was changed.\n\n"  if @changed == TRUE
  end