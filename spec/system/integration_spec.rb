require 'spec_helper_system'

describe 'integrated tests' do
  pp = %q{
    class { 'pulp': }
    class { 'pulp::server': }
    class { 'pulp::admin_client': }
    class { 'pulp::consumer': }
  }

  # In case this isn't our first rodeo
  before(:all) { shell 'pulp-consumer -u admin -p admin unregister' }
  after(:all) { shell 'pulp-consumer -u admin -p admin unregister' }

  before { puppet_apply pp }

  it { should_not be_nil }

  it 'should login successfully' do
    result = shell 'pulp-admin login -u admin -p admin'
    expect(result.exit_code).to be_zero
  end

  it 'should register consumers' do
    result = shell 'pulp-consumer -u admin -p admin register --consumer-id=test'
    expect(result.exit_code).to be_zero
  end
end
