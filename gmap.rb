# GoogleMapの検索履歴リストを作成します。
# https://takeout.google.com/settings/takeout/ ここからダウンロードできます
# bodyタグ内だけにしてください

require 'csv'
require 'pry'

results = []

file = File.open('./my_activity.html')
data = []

file.each_line do |line|
  case data.length
  when 0
    matched_data = line.match(/<a href="(https:\/\/www\.google\.co\.jp\/maps\/search.+)">(.+)<\/a>/)
    next if matched_data == nil
    data << matched_data[2]
    data << matched_data[1]
  when 2
    next if data.length == 0
    matched_data = line.match(/<br>(.+)<\/div>/)
    next if matched_data == nil
    data << matched_data[1]
  when 3
    results << data
    data = []
  end
end

timestamp = Time.now.strftime('%Y%m%d_%H%M%S')

results.each do |result|
  CSV.open("./map_data/result_#{timestamp}.csv", 'a') do |csv|
    csv << result
  end
end

