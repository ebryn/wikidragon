# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def flash_msg type 
    content_tag( :div, flash[ type ].to_s, :class => "flash-msg #{type}", :style => flash[ type ] ? nil : 'display: none' )
  end

end
