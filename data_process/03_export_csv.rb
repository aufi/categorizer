require 'elasticsearch'
require 'csv'

ES = Elasticsearch::Client.new url: 'http://10.2.22.233:9200'

d = ES.search index: 'featured_documents', body: { query: {"query":{"match_all":{}}}, size: 9999, from: 0 } # size: 9999

def select_features(attrs)
  features = []
  attrs.each_pair do |k, v|
    features << v if k.start_with? 'feature_'
  end
  features
end

def select_feature_names(attrs)
  features = ['id']
  attrs.each_pair do |k, v|
    features << k if k.start_with? 'feature_'
  end
  features
end

data = d['hits']['hits']

csv_string = CSV.generate(write_headers: true, headers: select_feature_names(data.first["_source"])) do |csv|
  data.each do |d|
    doc = d["_source"]
    csv << [d["_id"], *select_features(doc)]
  end
end

puts csv_string
