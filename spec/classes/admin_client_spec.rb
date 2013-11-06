require 'spec_helper'
require 'classes/shared_admin_client_packages'
require 'classes/shared_admin_client_conf'

describe 'pulp::admin_client' do
  it { should_not be_nil }

  context 'with default params' do
    include_context :admin_client_packages_present
    include_context :admin_client_conf_present
    include_context :admin_client_conf_default_template
  end

  context 'conf_template => test/admin.conf.erb' do
    let(:params) { { :conf_template => 'test/admin.conf.erb' } }

    include_context :admin_client_conf_test_template
  end

  context 'ensure => present' do
    let(:params) { { :ensure => 'present' } }

    include_context :admin_client_packages_present
    include_context :admin_client_conf_present
    include_context :admin_client_conf_default_template
  end

  context 'ensure => 2.2.0-1.el6' do
    let(:version) { '2.2.0-1.el6' }
    let(:params) { { :ensure => version} }

    include_context :admin_client_packages_pinned
    include_context :admin_client_conf_present
    include_context :admin_client_conf_default_template
  end

  context 'ensure => absent' do
    let(:params) { { :ensure => 'absent' } }

    include_context :admin_client_packages_absent
    include_context :admin_client_conf_absent
  end
end
