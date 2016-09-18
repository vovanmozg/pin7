require 'net/http'
require 'uri'
require 'http-cookie'

# https://web.archive.org/web/20090221141735/http://snippets.dzone.com/posts/show/788
class Browser

  def initialize
    @jar = HTTP::CookieJar.new
  end

  def get(url)
    uri = URI.parse(url)
    @host = uri.host
    http = Net::HTTP.new @host
    path = uri.path

    headers = {
        'Cookie' => HTTP::Cookie.cookie_value(@jar.cookies("http://#{@host}"))
    }

    resp = http.get2(path, headers)
    if resp.response['set-cookie']
      cookie = resp.response['set-cookie'].split('; ')[0]
      #@cookie = cookie # only one kuka
      @jar.parse(cookie, "http://#{@host}")
    end

    resp.body

    # Output on the screen -> we should get either a 302 redirect (after a successful login) or an error page
    #   puts 'Code = ' + resp.code
    #   puts 'Message = ' + resp.message
    #   resp.each { |key, val| puts key + ' = ' + val }
    #   puts data
  end

  def post(url, data)
    uri = URI.parse(url)
    @host = uri.host
    http = Net::HTTP.new @host
    path = uri.path

    data = data.map{|k, v| "#{k}=#{v}" }.join('&')

    headers = {
        'Cookie' => HTTP::Cookie.cookie_value(@jar.cookies("http://#{@host}")),
        'Referer' => "http://#{@host}",
        #'Origin' => "http://#{@host}",
        'Content-Type' => 'application/x-www-form-urlencoded',
        #'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        #'Accept-Encoding' => 'gzip, deflate',
        #'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4',
        #'Cache-Control' => 'no-cache',
        #'Connection' => 'keep-alive',
        #'Pragma' => 'no-cache',
        #'Upgrade-Insecure-Requests' => '1',
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36',
        #'X-Compress' => 'null'
    }

    resp = http.post(path, data, headers)
    # puts 'Code = ' + resp.code
    # puts 'Message = ' + resp.message
    # resp.each { |key, val| puts key + ' = ' + val }
    resp.body
  end
end