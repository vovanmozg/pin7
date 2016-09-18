require 'curb'
require 'nokogiri'
require 'dotenv'
Dotenv.load
# create .env file with vars PIN7_PHPSESSID=xxx and PIN7_PASSWORD=xxx

def main
  init
  login
  # search
  # pages
end

def init
  $c = Curl::Easy.new

end

def urltofile(url)
  url.gsub(/[^a-zA-Z0-9]/, '')[10..50]
end


def post_page(url, post)



  # http = Curl.post(url, post) do |http|
  #   http.headers['Cookie'] = "PHPSESSID=#{ENV['PIN7_PHPSESSID']}"
  # end
  #
  # IO.write "data/#{urltofile "#{url}#{post}"}.htm", http.body_str
end

def get_page(url)
  http = Curl.post(url)
  IO.write "data/#{urltofile url}.htm", http.body_str
end

def login
  # $c.url = 'http://pin7.ru/'
  # p $c.http_post(
  #     Curl::PostField.content('fgo', '%C2%F5%EE%E4'),
  #     Curl::PostField.content('fpin', ENV['PIN7_PASSWORD'])
  # )



  # авторизация
  post_page('http://pin7.ru/', {
      fgo: '%C2%F5%EE%E4',
      fpin: 77777}
  )
  get_page("http://pin7.ru")
end

def search
  post_page("http://pin7.ru/search.php", {
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
end

def pages
  (1..6).to_a.each do |p|
    get_page("http://pin7.ru/search.php?a=1&numpage=#{p}")
  end
end

main