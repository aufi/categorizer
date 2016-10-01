require 'elasticsearch-ruby'

ES = Elasticsearch::Client.new url: 'http://127.0.0.1:9200'

REGEXP_SELECTORS = [
  {name: 'stavebni', regex: /stavební/},
  {name: 'prodej', regex: /prodej/},
  {name: 'drazebni', regex: /dražba/},
  {name: 'eia', regex: /životní prostředí/},
]

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

step = 9999

0..25.times do |i| # fixed document count, do it better in future
  d = ES.search index: 'raw_documents', body: { query: {"query":{"match_all":{}}}, size: step, from: i * step }

  data = d['hits']['hits']

  data.each do |d|
    assign_regex_cat(d)
  end

  p data.count
end
