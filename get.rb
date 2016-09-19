require 'curb'
require 'nokogiri'
require 'dotenv'
require "#{__dir__}/browser"
Dotenv.load
# create .env file with vars PIN7_PHPSESSID=xxx and PIN7_PASSWORD=xxx

HOST = 'pin7.ru'
CACHE = 60 * 60

def main
  init
  login
  search
  flats = pages
  template = IO.read 'data/map-template.htm'
  IO.write 'data/map.htm', template.gsub(/POINTS/, flats.map{|f| "'#{f}'"}.join(','))
end

def init
  $b = Browser.new
end

# def get_page(url)
#   http = Curl.post(url)
#   IO.write "data/#{urltofile url}.htm", http.body_str
# end

def login
  get "http://#{HOST}/", cache_age: CACHE
  post "http://#{HOST}/", {fgo: '%C2%F5%EE%E4', fpin: 77777}, cache_age: CACHE
  get "http://#{HOST}/online.php", cache_age: CACHE
end

def search
  d = $b.post("http://#{HOST}/search.php", {
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
  flats = []
  (1..6).to_a.each do |p|
    content = get "http://pin7.ru/search.php?a=1&numpage=#{p}", cache_age: 0
    content.force_encoding("cp1251").encode("utf-8", undef: :replace)
    doc = Nokogiri::HTML content
    doc.css('table.tbm_01 tr').each do |row|
      address = ''
      address_td = row.css('.tdm_02')
      # Если контентная строка, а не заголовок
      if address_td.count > 0
        # убрать ссылки на карту
        address_td.at_css('table').content = ''
        additional_address_em = address_td.at_css('em')
        additional_address = ''
        if additional_address_em
          additional_address = additional_address_em.text
          additional_address_em.content = ''
        end
        flats << "#{address_td.text.split.join(' ')} #{additional_address}"
      end
    end
    sleep 1
  end
  return flats
end

def get(url, cache_age: 0)
  go url, cache_age: cache_age
end

def post(url, data, cache_age: 0)
  go url, data: data, cache_age: cache_age
end

def go(url, data: nil, cache_age: 0)
  if data
    body = $b.post url, data, cache_age: cache_age
  else
    body = $b.get url, cache_age: cache_age
  end
end


main

