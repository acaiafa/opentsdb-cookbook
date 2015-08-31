require 'spec_helper'

describe_recipe 'opentsdb::default' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  context 'with default attributes' do
    it { expect(chef_run).to create_opentsdb_instance('test') }
    it { expect(chef_run).to enable_opentsdb_instance('test') }

    it 'converges successfully' do
      chef_run
    end
  end
end
