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
    include_context :server_conf_default_template
  end

  context 'ensure => present' do
    let(:params) { { :ensure => 'present' } }
    include_context :server_packages_present
    include_context :server_conf_present
    include_context :server_services_running
    include_context :server_setup_db

    context 'conf_template => test/server.conf.erb' do
      let(:params) do
        { :ensure => 'present',
          :conf_template => 'test/server.conf.erb' }
      end
      include_context :server_conf_test_template
    end

    context 'with default conf_template' do
      include_context :server_conf_default_template
    end
  end

  context 'ensure => 2.2.0-1.el6' do
    let(:params) { { :ensure => version } }
    let(:version) { '2.2.0-1.el6' }

    include_context :server_packages_pinned
    include_context :server_conf_present
    include_context :server_services_running
    include_context :server_setup_db
  end


  context 'ensure => absent' do
    let(:params) { { :ensure => 'absent' } }
    include_context :server_packages_absent
    include_context :server_conf_absent
    include_context :server_services_stopped
  end
end
