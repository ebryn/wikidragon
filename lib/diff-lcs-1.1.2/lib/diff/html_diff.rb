# HTML Diff
#
# Usage: html_diff( original_html, new_html )
# 
# This is free software. It may be redistributed and/or modified
# under the terms of the GPL version 2 (or later), the Perl Artistic
# licence, or the Ruby licence.

require File.dirname(__FILE__) + '/lcs'

WHITESPACE = /[ \t]+/  # note that we leave newlines alone

def html_diff( a, b, insert_tag='ins', delete_tag='del', delete_class=nil, insert_class=nil )
  
  # keep whole words together
  a = a.gsub( /(\r?\n)/, ' \1 ' ).gsub( /(<.+?>)/, ' \1 ' ).split( WHITESPACE )
  b = b.gsub( /(\r?\n)/, ' \1 ' ).gsub( /(<.+?>)/, ' \1 ' ).split( WHITESPACE )

  delete_class = %{ class="#{delete_class}"} if delete_class
  insert_class = %{ class="#{insert_class}"} if insert_class
  delete_opening_tag = "<#{delete_tag}#{delete_class}>"
  delete_closing_tag = "</#{delete_tag}>"
  insert_opening_tag = "<#{insert_tag}#{insert_class}>"
  insert_closing_tag = "</#{insert_tag}>"
  
  html = ''
  deletion = ''
  addition = ''
  diff = Diff::LCS.sdiff( a, b )

  diff.each do |context_change| 
    deletion << "#{context_change.old_element} " if ( context_change.deleting? || context_change.action=='!' )
    addition << "#{context_change.new_element} " if ( context_change.adding?   || context_change.action=='!' )

    if !deletion.empty? && ( context_change.adding? || context_change.unchanged? )
      html.gsub!( / +$/, '' )
      html << " #{delete_opening_tag}#{deletion.strip}#{delete_closing_tag} "
      deletion = ''
    end

    if !addition.empty? && ( context_change.deleting? || context_change.unchanged? )
      html.gsub!( / +$/, '' )
      html << " #{insert_opening_tag}#{addition.strip}#{insert_closing_tag} "
      addition = ''
    end
    
    if context_change.unchanged?
      html.gsub!( / +$/, '' )
      html << " #{context_change.new_element} "
    end
    
  end
  
  html.gsub!( / +$/, '' )
  html << " #{delete_opening_tag}#{deletion.strip}#{delete_closing_tag} " if !deletion.empty?
  html << " #{insert_opening_tag}#{addition.strip}#{insert_closing_tag} " if !addition.empty?

  # html.gsub!( / +/, ' ' )  
  html.gsub!( /^ +/, '' )
  html.gsub!( / +$/, '' )
  html.gsub!( %r{(<[^/]+?>) +}, '\1' )   # remove any spaces after opening html tags (eg <span>)
  html.gsub!( %r{ +(</.+?>)}, '\1' )       # remove any spaces before closing html tags (eg </span>)
  html
end