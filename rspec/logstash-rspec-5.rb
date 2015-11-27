# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"

# running the grok code outside a logstash package means
# LOGSTASH_HOME will not be defined, so let's set it here
# before requiring the grok filter
unless LogStash::Environment.const_defined?(:LOGSTASH_HOME)
  LogStash::Environment::LOGSTASH_HOME = File.expand_path("../../../", __FILE__)
end

require "logstash/filters/grok"

describe LogStash::Filters::Grok do

  describe  "grok text that start with test" do
    config <<-CONFIG
      filter {
        grok {
            match => {"message" =>"%{WORD:prefix} +%{GREEDYDATA:msg}" }
            remove_field => ["@version"]
            tag_on_failure => "no match for the pattern"
        }
      }
    CONFIG

    sample "test hello world" do
      insist { subject["prefix"] } == "test"
      insist { subject["msg"] } ==  "hello world"
    end

    sample "test " do
      insist { subject["prefix"] } == "test"
      insist { subject["msg"] }.nil?
    end

    sample "test" do
      insist { subject["prefix"] }.nil?
      insist { subject["msg"] }.nil?
      insist { subject["tags"]} == ["no match for the pattern"]
    end
  end

end
