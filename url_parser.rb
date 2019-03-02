class UrlParser
  attr_accessor :url, :scheme, :domain, :port, :path, :query_string, :fragment_id
  def initialize(url)
    @url = url
    working_url = url


    @scheme = url[0..(url.index(':') -1)]
    working_url = working_url[(working_url.index(':')+3)..-1]


    colon = working_url.index(':')
    slash = working_url.index('/')
    first = [colon, slash].compact.min
    @domain = working_url[0..(first -1)]
    working_url = working_url[(first)..-1]

    if working_url[0] == ':'
      working_url = working_url[1..-1]
      @port = working_url[0..(working_url.index('/') -1)]
      working_url = working_url[(working_url.index('/') + 1)..-1]
    elsif @scheme == 'http'
      @port = '80'
      working_url = working_url[1..-1]
    elsif @scheme == 'https'
      @port = '443'
      working_url = working_url[1..-1]
    end

    fragment_id_start = working_url.index('#')
    if(fragment_id_start)
      @fragment_id = working_url[(fragment_id_start +1)..-1]
      working_url = working_url[0..fragment_id_start -1]
    end

    query_start = working_url.index('?')
    if(!query_start)
      @path = working_url
      working_url = ''
    elsif query_start != 0
      @path = working_url[0..query_start -1]
      working_url = working_url[(query_start + 1)..-1]
    else
      working_url = working_url[1..-1]
    end

    @query_string = {}
    while working_url.length > 0 do
      key = working_url[0..working_url.index('=') -1]
      finish = working_url.index('&') ? working_url.index('&') -1 : -1
      value = working_url[(working_url.index('=') + 1)..finish]
      @query_string.merge!(key => value)
      if(working_url.index('&'))
        working_url = working_url[(finish + 2)..-1]
      else
        working_url = ''
      end
    end
  end
end

new_url = UrlParser.new "http://www.google.com:60/search?q=cat&name=Tim#img=FunnyCat"
new_url2 = UrlParser.new "https://www.google.com/?q=cat#img=FunnyCat"
insecure_url = UrlParser.new "http://www.google.com/search"
