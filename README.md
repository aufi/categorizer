# Categorizer, Prague hacks 2016 project

## Steps

```$ git clone git@github.com:aufi/categorizer.git```

```$ cd categorizer/data_process && bundle```

Create data directory with data from Lukas and return to categorizer directory

```$ ruby data_process/01_load_to_es.rb```

```$ ruby data_process/02_features_regex.rb```

```$ ruby data_process/03_export_csv.rb```

## Notes

Requirements: Ruby

elasticsearch local endpoint http://10.2.22.233:9200/_plugin/head/
