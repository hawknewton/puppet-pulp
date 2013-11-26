require 'spec_helper_system'

describe 'pulp consumer spec' do

  before do
    manifest = %q{
      class {'pulp': }
      class {'pulp::server': }
      class {'pulp::admin_client': }
      class {'pulp::consumer': }
    }

    puppet_apply manifest
  end

  after { shell 'pulp-consumer unregister' }

  it 'should register with server' do
    manifest = %q{
      pulp_consumer { 'test_consumer':
        ensure => 'present',
        login  => 'admin',
        password => 'admin'
      }
    }

    puppet_apply manifest do |r|
      expect(r.exit_code).to eq 2
      expect(r.stderr).to be_empty
    end

    shell 'pulp-consumer status' do |r|
      expect(r.stdout.gsub "\n", ' ').to match /This consumer is registered to the server .+ with the ID \[test_consumer\]/
    end
  end

  it 'should unregister with the server' do
    shell 'pulp-consumer -u admin -p admin register --consumer-id=test_consumer'

    manifest = %q{
      pulp_consumer { 'test_consumer':
        ensure => 'absent',
        login  => 'admin',
        password => 'admin'
      }
    }

    puppet_apply manifest do |r|
      expect(r.exit_code).to eq 2
      expect(r.stderr).to be_empty
    end
  end
end
