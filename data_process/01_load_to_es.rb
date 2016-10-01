require 'elasticsearch'
require 'json'

ES = Elasticsearch::Client.new log: true, url: 'http://10.2.22.233:9200'

TITLES = JSON.load(File.read('data/titles.id.txt'))

def load_files_to_es(path = './data')
  subdirs = Dir.entries(path).select {|fname| fname =~ /\d+/ }
  subdirs.each do |subdir|
    puts subdir
    files = Dir.entries([path, subdir].join '/').select {|fname| fname =~ /\d+\.txt/ }.each do |f|
      puts f
      id = f.gsub(/[^0-9]/, '')
      es_store_doc id, categories: '', name: TITLES[id], text: File.read([path, subdir, f].join '/')
    end
  end
end

def es_store_doc(id, data)
  ES.index  index: 'raw_documents', type: 'document', id: id, body: data
end

#

puts '01_load_to_es'

load_files_to_es
