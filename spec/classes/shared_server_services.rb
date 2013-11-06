require 'spec_helper'

shared_context :server_services_running do
  let(:service_params) do
    { :ensure => 'running',
      :require => 'File[/etc/pulp/server.conf]' }
  end

  it { should contain_service('mongod').with(service_params) }
  it { should contain_service('qpidd').with(service_params) }

  it do
    should contain_service('httpd').with({
      :ensure    => 'running',
      :subscribe => 'Exec[setup-pulp-db]'
    })
  end
end


shared_context :server_services_stopped do
  it { should contain_service('mongod').with(:ensure => 'stopped') }
  it { should contain_service('qpidd').with(:ensure => 'stopped') }
end
