require 'spec_helper'

describe 'titan::default' do
  context 'with default settings' do
    cached(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

    it 'creates the titan group' do
      expect(chef_run).to create_group('titan')
    end

    it 'creates the titan user' do
      expect(chef_run).to create_user('titan').with(
        gid: 'titan',
        home: '/opt/titan/'
      )
    end

    it 'creates the remote file titan-0.5.2-hadoop1.zip' do
      expect(chef_run).to create_remote_file_if_missing('/tmp/titan-0.5.2-hadoop1.zip').with(
        source: 'http://s3.thinkaurelius.com/downloads/titan/titan-0.5.2-hadoop1.zip',
        owner: 'titan',
        group: 'titan'
      )
    end

    it 'creates the install directory /opt/titan' do
      expect(chef_run).to create_directory('/opt/titan/').with(
        owner: 'titan',
        group: 'titan',
        mode: '755'
      )
    end

    it 'installs the unzip package from default repository' do
      expect(chef_run).to install_package('unzip')
    end

    it 'uses bash to extract the zip archive and move it to the install directory' do
      expect(chef_run).to run_bash('extract /tmp/titan-0.5.2-hadoop1.zip, move it to /opt/titan/').with(
        user: 'titan',
        group: 'titan',
        cwd: '/tmp',
        creates: '/opt/titan//bin/titan.sh'
      )
    end

    it 'creates the cassandra config, only if it is set to manage the cassandra config' do
      expect(chef_run).to create_template('/opt/titan/conf/cassandra.yaml').with(
        source: 'cassandra.yaml.erb',
        owner: 'titan',
        group: 'titan',
        mode: '755'
      )
    end

    it 'creates the template /opt/titan/conf/cassandra.yaml that matches the one in ./spec/rendered_templates' do
      rendered_template = File.read('./spec/rendered_templates/cassandra.yaml')
      expect(chef_run).to render_file('/opt/titan/conf/cassandra.yaml').with_content(rendered_template)
    end

    it 'creates the titan server to cassandra properties file' do
      expect(chef_run).to create_template('/opt/titan/conf/titan-server-cassandra-es.properties').with(
        source: 'titan-server-cassandra-es.properties.erb',
        owner: 'titan',
        group: 'titan',
        mode: '755'
      )
    end

    it 'creates the template /opt/titan/conf/titan-server-cassandra-es.properties that matches the one in ./spec/rendered_templates' do
      rendered_template = File.read('./spec/rendered_templates/titan-server-cassandra-es.properties')
      expect(chef_run).to render_file('/opt/titan/conf/titan-server-cassandra-es.properties').with_content(rendered_template)
    end

    it 'creates the rexster cassandra xml file' do
      expect(chef_run).to create_template('/opt/titan/conf/rexster-cassandra-es.xml').with(
        source: 'rexster-cassandra-es.xml.erb',
        owner: 'titan',
        group: 'titan',
        mode: '755'
      )
    end

    it 'creates the titan init conf file' do
      expect(chef_run).to create_template('/etc/init/titan.conf').with(
        source: 'titan.upstart.conf.erb',
        owner: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it 'creates the template /etc/init/titan.conf that matches the one in ./spec/rendered_templates' do
      rendered_template = File.read('./spec/rendered_templates/titan.conf')
      expect(chef_run).to render_file('/etc/init/titan.conf').with_content(rendered_template)
    end

    it 'starts the service titan' do
      expect(chef_run).to start_service('titan')
    end
  end
end
