#!/usr/bin/env ruby

require 'yaml'
require 'feedlr'

config = YAML.load_file('config.yml')

client = Feedlr::Client.new(
  oauth_access_token: config['access_token'],
)

category = client.user_categories.delete_if do |category|
  category['label'] != config['label']
end .first
contents = client.stream_entries_contents(category['id'],
  count: config['count'],
)

contents['items'].shuffle.each do |item|
  title = item['title']

  short = title.gsub(/w+/, 'w').gsub(/ｗ+/, 'ｗ')
  short = short.length <= 50 ? short : short[0..49] + ' いかりゃく'

  `osascript -e 'display notification "#{title}" with title "Matome Feed" sound name "Pop"'`
  `osascript -e 'set volume output volume 37'`
  `say #{short}`
  `osascript -e 'set volume output volume 63'`

  sleep config['sleep']
end
