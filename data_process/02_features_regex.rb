require 'elasticsearch'
require 'json'

ES = Elasticsearch::Client.new log: true, url: 'http://10.2.22.233:9200'
