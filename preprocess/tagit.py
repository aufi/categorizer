import glob
import json
import math
import re

titles = json.load(open("../titles.id.txt"))

keywords = []
for line in open('keywords.regexp').read().split("\n"):
    if line != '':
        keywords.append(r'%s' % line)

class Classifier:
    patterns = []

    def __init__(self):
        for pattern in open("patterns.txt").read().split("\n"):
            pattern = re.sub(r'/ #.*$/', '', pattern)
            splitted = pattern.rsplit(',', 1)
            print(splitted)
            if len(splitted) == 2:
                regexp, category = splitted
                regexp = re.search(r'\/(.*)\/', regexp).group(1)
                category = re.search(r'\'(.*)\'', category).group(1)
                self.patterns.append({'category': category, 'regexp': r'\b{0}\b'.format(regexp)})

    def run(self, text):
        categories = []
        for pattern in self.patterns:
            if re.search(pattern['regexp'], text, re.IGNORECASE):
                categories.append(pattern['category'])
        return categories

    def features_vec(self, text):
        keywords_vec = []
        regexp_vec   = []
        sizes_vec    = [
            min([1, math.log(len(text),10)/10]),
            min([1, math.log(len(re.split(text, r'\s+')),10)/10]),
            min([1, math.log(len(re.split(text, r'\n\s\n')),10)/10])
        ]
        for k in keywords:
            keywords_vec.append(1 if re.search(k, text, re.IGNORECASE) else 0)
        for k in self.patterns:
            regexp_vec.append(1 if re.search(k, text, re.IGNORECASE) else 0)
        return keywords_vec + regexp_vec + sizes_vec


c = Classifier()

print(len(c.patterns))

def get_categories(id, title, text):
    print("=" * 80)
    categories = set(c.run(text))
    print("###{0}:{1}".format(id, ','.join(categories)))
    print("")
    print(categories)
    print("")
    print(text)

for fname in glob.glob("../data/*/*.txt"):
    id = re.search(r'\d+\/(\d+)\.txt', fname).group(1)
    title = titles[id] # fails when not found
    body = open(fname).read()
    content = '\n'.join([title, body])
    #get_categories(id, title, content)
    print(c.features_vec(content)) #.unshift(id).join(',')
