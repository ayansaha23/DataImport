# DataImport

This is an utility tool that is used to import csv file of Attributions into redis db.

There should be redis server running, for any customisations update the redis_host and redis_port config values.

This is a console application and can by

1.Install gems
```sh
 bundle install
```

2.Run application from rails console

````bash
rails c
AdAttribution.import(file_path: 'app/models/attributions.csv')
````
3.Check redis server for the values inserted.