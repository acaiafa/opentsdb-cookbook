require 'spec_helper'

describe service('opentsdb-write') do
  it { should be_enabled }
  it { should be_running }
end

describe service('opentsdb-read') do
  it { should be_enabled }
  it { should be_running }
end
