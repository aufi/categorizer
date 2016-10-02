import glob
import json
import re

titles = json.load(open("../titles.id.txt"))

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
    get_categories(id, title, "\n".join([title, body]))
