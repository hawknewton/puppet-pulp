require 'spec_helper'

shared_context :shared_server_config_present do
  example do
    should contain_file('/etc/pulp/server.conf').with({
      ensure: 'present',
      owner: 'root',
      group: 'root',
      mode: '644',
      require: 'Package[pulp-server]'
    })
  end
end

shared_context :shared_server_config_absent do
  example do
    should contain_file('/etc/pulp/server.conf').with({
      ensure: 'absent'
    })
  end
end
