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

elasticsearch local endpoint http://10.2.22.233:9200/_plugin/head/ with sample data or elasticsearch at our VM is available

Extend max result window: curl -XPUT "http://localhost:9200/my_index/_settings" -d '{ "index" : { "max_result_window" : 500000 } }'
