require 'spec_helper'
require 'classes/shared_server_packages'
require 'classes/shared_server_conf'
require 'classes/shared_server_services'
require 'classes/shared_server_setup_db'

describe 'pulp::server' do
  it { should_not be_nil }

  context 'with default params' do
    include_context :server_packages_present
    include_context :server_conf_present
    include_context :server_services_running
    include_context :server_setup_db
  end

  context 'ensure => present' do
    let(:params) { { ensure: 'present' } }
    include_context :server_packages_present
    include_context :server_conf_present
    include_context :server_services_running
    include_context :server_setup_db

    context 'server_conf => asdf' do
      let(:params) do
        { ensure: 'present',
          server_conf: 'asdf' }
      end
      include_context :server_conf_content_asdf
    end

    context 'with default content' do
      include_context :server_conf_default_content
    end
  end

  context 'ensure => 2.2.0-1.el6' do
    let(:params) { { ensure: version } }
    let(:version) { '2.2.0-1.el6' }

    include_context :server_packages_pinned
    include_context :server_conf_present
    include_context :server_services_running
    include_context :server_setup_db
  end


  context 'ensure => absent' do
    let(:params) { { ensure: 'absent' } }
    include_context :server_packages_absent
    include_context :server_conf_absent
    include_context :server_services_stopped
  end
end
