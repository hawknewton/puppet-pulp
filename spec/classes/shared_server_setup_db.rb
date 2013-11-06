require 'spec_helper'

shared_context :server_setup_db do
  it { should contain_exec('setup-pulp-db').with({
    :command => '/usr/bin/pulp-manage-db',
    :refreshonly => 'true',
    :tries => 12,
    :try_sleep => 10,
    :require => ['Service[mongod]', 'Service[qpidd]']
  }) }
end


