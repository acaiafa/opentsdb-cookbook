require 'spec_helper'

describe service('opentsdb') do
  it { should be_enabled }
  it { should be_running }
end
