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
        csv {
          columns => ["CASE_NO", "CASE_STATUS", "CASE_SUBMITTED", "DECISION_DATE", "VISA_CLASS", "EMPLOYMENT_START_DATE", "EMPLOYMENT_END_DATE", "EMPLOYER_NAME", "EMPLOYER_ADDRESS1", "EMPLOYER_ADDRESS2", "EMPLOYER_CITY", "EMPLOYER_STATE","EMPLOYER_POSTAL_CODE","EMPLOYER_COUNTRY","EMPLOYER_PROVINCE","EMPLOYER_PHONE","EMPLOYER_PHONE_EXT","AGENT_ATTORNEY_NAME","AGENT_ATTORNEY_CITY","AGENT_ATTORNEY_STATE","JOB_TITLE","SOC_CODE","SOC_NAME","NAIC_CODE","TOTAL WORKERS","FULL_TIME_POSITION","PREVAILING_WAGE","PW_UNIT_OF_PAY","PW_WAGE_LEVEL","PW_WAGE_SOURCE","PW_WAGE_SOURCE_YEAR","PW_WAGE_SOURCE_OTHER","WAGE_RATE_OF_PAY","WAGE_UNIT_OF_PAY","H-1B_DEPENDENT","WILLFUL VIOLATOR","WORKSITE_CITY","WORKSITE_COUNTY","WORKSITE_STATE","WORKSITE_POSTAL_CODE"]
          remove_field => ["@version", "host", "AGENT_ATTORNEY_NAME", "AGENT_ATTORNEY_CITY", "AGENT_ATTORNEY_STATE", "EMPLOYER_PHONE_EXT", "EMPLOYER_PROVINCE"]
        }
      }
    CONFIG

    sample "I-200-09121-701936,WITHDRAWN,2/5/15,2/5/15,H-1B,02/09/2015,02/28/2015,\"MEDTRONIC, INC.\",710 MEDTRONIC PARKWAY NE,,MINNEAPOLIS,MN,55432,UNITED STATES OF AMERICA,,7635052710,,DEBRA SCHNEIDER,MINNEAPOLIS,MN,MECHANICAL ENGINEER,17-2141.00,MECHANICAL ENGINEERS,334510,1,Y,19000.00,Year,Level I,OES,2014,ONLINE DATA SURVEY,20000 -,Year,N,N,EDEN PRAIRIE,STERNS,CA,55412" do
      insist { subject["CASE_NO"] } == "I-200-09121-701936"
      insist { subject["EMPLOYER_NAME"] } == "MEDTRONIC, INC."
      insist { subject["WORKSITE_POSTAL_CODE"] } == "55412"
      insist { subject["AGENT_ATTORNEY_NAME"] }.nil?
    end
  end

end
