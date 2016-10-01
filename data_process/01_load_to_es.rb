require 'elasticsearch'
require 'json'

ES = Elasticsearch::Client.new url: 'http://10.2.22.233:9200'

TITLES = JSON.load(File.read('data/titles.id.txt'))

def load_files_to_es(path = './data')
  subdirs = Dir.entries(path).select {|fname| fname =~ /\d+/ }
  subdirs.each do |subdir|
    puts subdir
    files = Dir.entries([path, subdir].join '/').select {|fname| fname =~ /\d+\.txt/ }.each do |f|
      puts f
      id = f.gsub(/[^0-9]/, '')
      ES.index index: 'raw_documents', type: 'document', id: id, body: {name: TITLES[id], text: File.read([path, subdir, f].join '/')}
    end
  end
end

load_files_to_es
