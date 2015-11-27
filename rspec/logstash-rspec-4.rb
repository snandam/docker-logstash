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


  describe  "grok with no coercion" do
    config <<-CONFIG
      filter {
        grok {
          match => { "message" => "test (N/A|%{BASE10NUM:duration}ms)" }
        }
      }
    CONFIG

    sample "test 28.4ms" do
      insist { subject["duration"] } == "28.4"
      insist { subject["tags"] }.nil?
    end

    sample "test N/A" do
      insist { subject["duration"] }.nil?
      insist { subject["tags"] }.nil?
    end
  end

end
