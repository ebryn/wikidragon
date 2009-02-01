class ScreenplayFormatter
  def self.from_text(text)
    new_text = ""
    text.split(/\r?\n/).each do |line|
      changes = line.gsub!(/^\s+([^a-z]+)\s*$/, "<div class=\"speaker\">\\1</div>\n")
      changes = line.gsub!(/^\s+(.+?)\s*$/, "<div class=\"dialog_line\">\\1</div>\n")     unless changes
      changes = line.gsub!(/^(\d+\. [^a-z]+?)\s*$/, "<div class=\"location\">\\1</div>\n") unless changes
      changes = line.gsub!(/^(.+?)\s*$/, "<div class=\"description\">\\1</div>\n")         unless changes
      new_text << line
    end
    new_text
  end
  
end