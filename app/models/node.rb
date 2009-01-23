require File.join( File.dirname(__FILE__), %w[ .. .. lib diff-lcs-1.1.2 lib diff html_diff ] )

class Node < ActiveRecord::Base

  belongs_to :user
  acts_as_tree :order => "title, created_at"  

  validates_presence_of     :title
  validates_presence_of     :content
#  validates_presence_of     :url
  validates_presence_of     :user

#  def after_save
#    self.url = "http://example.com/nodes/#{user.name_for_url}/#{title_for_url}/2008_01_01_11_59_01"
#  end

  def content_html
    BlueCloth.new( self.content ).to_html
  end

  def remix( args )
    self.children.create!( args )
  end

  def Node.most_recent_with_title( title )
    Node.find :first, :order => 'updated_at DESC', :conditions => [ 'title=?', title.gsub( '_', ' ' ) ]
  end

  # Display the content of both nodes, highlighting differences as insertions and deletions.
  # Content in this node that is not in the other should appear as an insertion.
  def self.html_content_with_differences( node1, node2 )
    html_diff( node1.content_html, node2.content_html )
  end

  def friendly_date
    created_at ? created_at.strftime( '%d %b %Y' ) : 'Date unknown'
  end

  def title_for_url
    title.gsub( /\s+/, '_' )
  end

end


