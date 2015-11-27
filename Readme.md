### Logstash up and running

##### Exercise 1 : Run logstash docker container and use stdin and stdout

```sh
docker run -it --rm logstash logstash -e 'input { stdin { } } output { stdout { } }'
```

###### Sample inputs
* test hello world
* test this is awesome
* test

###### Notes/Reference:
* https://hub.docker.com/_/logstash/

##### Exercise 2 : Run logstash stdin and stdout but with a configuration file
```sh
docker run -it --rm -v "$PWD/config-dir":/config-dir logstash logstash -f /config-dir/logstash-2.conf
```

###### Sample inputs
* test hello world
* test this is awesome
* test

###### Notes/Reference
* https://www.elastic.co/guide/en/logstash/current/plugins-outputs-stdout.html


##### Exercise 3: Check if logstash configuration file is valid
```sh
docker run -it --rm -v "$PWD/config-dir":/config-dir logstash logstash --configtest --config /config-dir/logstash-3.conf
```

###### Notes/Reference
* https://koendc.github.io/2013/10/11/logstash-test-configuration.html

##### Exercise 4: Run a sample rspec test to test a grok pattern
```sh
docker run -it --rm -v "$PWD/rspec":/rspec-dir gunmetalz/logstash:2.1 rspec /rspec-dir/logstash-rspec-4.rb
```
###### Notes/Reference:
Created a docker image which has logstash development tools installed. See rspec/readme.md

* https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html
* https://www.elastic.co/blog/logstash-functionality-through-testing
* https://raw.githubusercontent.com/logstash-plugins/logstash-filter-grok/master/spec/filters/grok_spec.rb

##### Exercise 5: Create a grok pattern to take stdin "test hello world" and the output should have field msg with "hello world" as content. Anything after test should become content. Write a spec file to test out the grok pattern and then test out the same with a logstash config. If there is no matching pattern add to a tag called "no match found for pattern", no need for @version

```sh
docker run -it --rm -v "$PWD/rspec":/rspec-dir gunmetalz/logstash:2.1 rspec /rspec-dir/logstash-rspec-5.rb

docker run -it --rm -v "$PWD/config-dir":/config-dir logstash logstash --configtest --config /config-dir/logstash-5.conf

docker run -it --rm -v "$PWD/config-dir":/config-dir logstash logstash -f /config-dir/logstash-5.conf
```
###### Sample inputs
* test hello world
* test this is awesome
* test

###### Notes/Reference:
* https://grokdebug.herokuapp.com/

#### Exercise 6: Use the data/h1b_testdata file and extract the data into specific columns as applies
```sh
docker run -it --rm -v "$PWD/rspec":/rspec gunmetalz/logstash:2.1 rspec /rspec/logstash-rspec-6.rb

docker run -it --rm -v "$PWD/config-dir":/config-dir logstash logstash --configtest --config /config-dir/logstash-6.conf

docker run -it --rm -v "$PWD/config-dir":/config-dir -v "$PWD/data":/data-dir logstash logstash -f /config-dir/logstash-6.conf
```

###### Notes/Reference:
* Large set of public data to play with
** http://www.flcdatacenter.com/CaseH1B.aspx
** http://www.foreignlaborcert.doleta.gov/performancedata.cfm
* Make sure of the line terminator of the input file. LF seems to be working fine.
