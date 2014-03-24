require 'spec_helper'

shared_context :server_conf_present do
  it do
    should contain_file('/etc/pulp/server.conf').with({
      :ensure  => 'present',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
      :require => 'Package[pulp-server]'
    })
  end
end

shared_context :server_conf_absent do
  it do
    should contain_file('/etc/pulp/server.conf').with({
      :ensure => 'absent'
    })
  end
end

shared_context :server_conf_test_template do
  it do
    should contain_file('/etc/pulp/server.conf').with_content /^This is a test template/
  end
end

shared_context :server_conf_default_template do
  let(:fqdn) { 'fqdn.myhost.com' }
  let(:facts) { { :fqdn => fqdn } }

  it do
    should contain_file('/etc/pulp/server.conf').with_content /^url: tcp:\/\/#{fqdn}:5672/
  end
end
