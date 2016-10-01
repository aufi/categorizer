require 'elasticsearch'

ES = Elasticsearch::Client.new url: 'http://10.2.22.233:9200'

REGEXP_SELECTORS = [
  {name: 'stavebni', regex: /stavební/},
  {name: 'prodej', regex: /prodej/},
  {name: 'drazebni', regex: /dražba/},
  {name: 'eia', regex: /životní prostředí/},
]

d = ES.search index: 'raw_documents', body: { query: {"query":{"match_all":{}}}, size: 9999, from: 0 } # size: 9999

def assign_regex_cat(record)
  doc = record["_source"]
  data = {}
  REGEXP_SELECTORS.each do |selector|
    content = [doc['name'], doc['text']].join('\n')
    data["feature_#{selector[:name]}"] = content.scan(selector[:regex]).length
  end
  data["text"] = doc['name']  # easy to read
  p data
  ES.index index: 'featured_documents', type: 'document', id: record['_id'], body: data
end

data = d['hits']['hits']

data.each do |d|
  assign_regex_cat(d)
end

p data.count
