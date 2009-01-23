class RemoteNodeController < ApplicationController
  before_filter :identify_user
  layout "nodes"
#  skip_before_filter :verify_authenticity_token, :only => :create

  def edit
    @source = {}
    @source[ :url ] = params[ :url ]
    url = %r{^https?://([^/]+)/.+/([^/]+)/$}.match( @source[ :url ] )
    @source[ :title ] = url[ 2 ]  # assumes selfdotpublish URL pattern
    site_name = url[ 1 ]
    source_markdown_url = "#{@source[ :url ]}content.markdown.txt"             # assumes selfdotpublish markdown file
    response = Net::HTTP.get_response( URI.parse( source_markdown_url ) )
    raise "Errors when getting '#{@source[ :url ]}': #{response.inspect}" unless response.kind_of? Net::HTTPSuccess
    @source[ :content ]= response.body
    @source[ :user ] = User.find_or_create_by_name( site_name )
    Node.create!( @source )
  end

  def update
    redirect_to root_path
  end

  #  def create
  #    node_params = params[ :node ].merge( :user_id => session[ :user_id ] )
  #    Node.create!( node_params )
  #  end

end
