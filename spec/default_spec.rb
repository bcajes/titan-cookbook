require 'spec_helper'

describe 'titan::default' do
  context 'with default settings' do
    cached(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }
  end
end
