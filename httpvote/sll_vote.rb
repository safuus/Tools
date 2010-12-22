require 'net/http'
require 'uri'
require 'iconv'


def vote

end

get_url = "http://35free.net/span1234/index.asp"
post_url = "http://35free.net/span1234/vote.asp"
test_url ="http://localhost:3000/pictures"

url = URI.parse(post_url)
post_uri = URI.parse(post_url)

getreq = Net::HTTP::Get.new(URI.parse(get_url).path)
postreq = Net::HTTP::Post.new(post_uri.path)

postreq['Host']='35free.net'
postreq['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13'
postreq['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
postreq['Accept-Language'] = 'en-us,en;q=0.5'
postreq['Accept-Encoding'] = 'gzip,deflate'
postreq['Accept-Charset']= 'ISO-8859-1,utf-8;q=0.7,*;q=0.7'
#postreq['Keep-Alive'] = '115'
postreq['Connection'] = 'keep-alive'
postreq['Referer'] = 'http://35free.net/span1234/index.asp'
postreq['X-Forwarded-For'] = '220.181.111.85'

succ_res = /投票成功/
count = 0;

cd = Iconv.new("UTF-8", "GB2312")

begin
until count == 300000 do
Net::HTTP.start(url.host, url.port) { | http|
  
  getres = http.request(getreq)
 5.times do |i| 
#  sleep_time = rand()/10
#  p "sleep #{sleep_time} seconds"
#  sleep sleep_time
  

#p getres
#p getres.to_hash

  postreq['Cookie'] = getres['set-cookie']


  postreq.set_form_data({'toupiao1'=>'93', 'toupiao'=>'49', 'Submit'=>'提交投票'})

  postreq.content_length = postreq.body.size

  res = postreq
#  p res
#  p res.to_hash
#  p Iconv.iconv("UTF-8", "GB2312",res.body)

  res = http.request(postreq)
#  p res
#  p res.to_hash
  p Iconv.iconv("UTF-8", "GB2312",res.body)
#  p res.body
  if (succ_res.match(cd.iconv(res.body)).length > 0) then
     count = count + 1
  end
  p "Vote #{count} times"
 end
}
end
rescue => err
  p err
  sleep_time = rand()
  p "sleep #{sleep_time} seconds"
  sleep sleep_time
  retry
end

