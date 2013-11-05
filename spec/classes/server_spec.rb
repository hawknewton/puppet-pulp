require 'spec_helper'
require 'classes/shared_server_packages'
require 'classes/shared_server_config'
require 'classes/shared_server_services'
require 'classes/shared_server_setup_db'

describe 'pulp::server' do
  it { should_not be_nil }

  context 'with default params' do
    include_context :shared_server_packages_present
    include_context :shared_server_config_present
    include_context :shared_server_services_running
    include_context :shared_server_setup_db
  end

  context 'ensure => present' do
    let(:params) { { ensure: 'present' } }
    include_context :shared_server_packages_present
    include_context :shared_server_config_present
    include_context :shared_server_services_running
    include_context :shared_server_setup_db
  end

  context 'ensure => 2.2.0-1.el6' do
    let(:params) { { ensure: version } }
    let(:version) { '2.2.0-1.el6' }

    include_context :shared_server_packages_pinned
    include_context :shared_server_config_present
    include_context :shared_server_services_running
    include_context :shared_server_setup_db
  end


  context 'ensure => absent' do
    let(:params) { { ensure: 'absent' } }
    include_context :shared_server_packages_absent
    include_context :shared_server_config_absent
    include_context :shared_server_services_stopped
  end
end
