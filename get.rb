require 'curb'
require 'nokogiri'
require 'dotenv'
require "#{__dir__}/browser"

Dotenv.load
# create .env file with vars PIN7_PHPSESSID=xxx and PIN7_PASSWORD=xxx

HOST = 'pin7.ru'


def main
  init
  login
  search
  # pages
end

def init
  $b = Browser.new
end

def urltofile(url)
  url.gsub(/[^a-zA-Z0-9]/, '')[10..50]
end

#
# def post_page(url, post)
#
#
#   # http = Curl.post(url, post) do |http|
#   #   http.headers['Cookie'] = "PHPSESSID=#{ENV['PIN7_PHPSESSID']}"
#   # end
#   #
#   # IO.write "data/#{urltofile "#{url}#{post}"}.htm", http.body_str
# end

# def get_page(url)
#   http = Curl.post(url)
#   IO.write "data/#{urltofile url}.htm", http.body_str
# end

def login
  $b.get("http://#{HOST}/")
  $b.post("http://#{HOST}/", { fgo: '%C2%F5%EE%E4', fpin: 77777})
  $b.get("http://#{HOST}/online.php")

  # $c.url = 'http://pin7.ru/'
  # p $c.http_post(
  #     Curl::PostField.content('fgo', '%C2%F5%EE%E4'),
  #     Curl::PostField.content('fpin', ENV['PIN7_PASSWORD'])
  # )


  #
  # # авторизация
  # post_page('http://pin7.ru/', {
  #     fgo: '%C2%F5%EE%E4',
  #     fpin: 77777}
  # )
  # get_page("http://pin7.ru")
end

def search

  d = $b.post("http://#{HOST}/search.php",  {
      sposob: 1,
      region: 1,
      tip_poiska: 2,
      oper: 1,
      term: 1,
      prod_ch0: '%ED%E5+%E2%E0%E6%ED%EE',
      est_ch_pro17: '2%EA.%EA%E2.',
      est_ch_pro18: '3%EA.%EA%E2.',
      est_ch_pro19: '4%EA.%EA%E2.',
      s_ch0: '%ED%E5+%E2%E0%E6%ED%EE',
      r_ch14: '%CC%EE%F1%EA%EE%E2%F1%EA%E8%E9',
      rlo_ch0: '%ED%E5+%E2%E0%E6%ED%EE',
      m_ch0: '%ED%E5+%E2%E0%E6%ED%EE',
      price1: 20000,
      price2: 40000,
      val: 'RUR',
      SearchGO: '%C8%F1%EA%E0%F2%FC',
      var_number: ''
  })

  IO.write 'data/temp.htm', d

end

def pages
  (1..6).to_a.each do |p|
    get_page("http://pin7.ru/search.php?a=1&numpage=#{p}")
  end
end

main