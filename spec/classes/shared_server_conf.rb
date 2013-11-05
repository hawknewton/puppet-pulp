require 'spec_helper'

shared_context :server_conf_present do
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

shared_context :server_conf_absent do
  example do
    should contain_file('/etc/pulp/server.conf').with({
      ensure: 'absent'
    })
  end
end

shared_context :server_conf_content_asdf do
  example do
    should contain_file('/etc/pulp/server.conf').with({
      content: 'asdf'
    })
  end
end

shared_context :server_conf_default_content do
  let(:fqdn) { 'fqdn.myhost.com' }
  let(:facts) { { fqdn: fqdn } }

  example do
    should contain_file('/etc/pulp/server.conf')
      .with_content /^url: tcp:\/\/#{fqdn}:5672/
  end
end
