require 'spec_helper'

shared_context :server_packages_base do
  let(:package_params) do
    { ensure: ensure_value,
      notify: 'Exec[setup-pulp-db]',
      before: ['Service[mongod]', 'Service[qpidd]'] }
  end
  it { should contain_package('pulp-server').with(package_params) }
  it { should contain_package('pulp-puppet-plugins').with(package_params) }
  it { should contain_package('pulp-puppet-plugins').with(package_params) }
  it { should contain_package('pulp-rpm-plugins').with(package_params) }
  it { should contain_package('pulp-selinux').with(package_params) }
  it { should contain_package('httpd').with(ensure: 'present') }
end

shared_context :server_packages_present do
  let(:ensure_value) { 'present' }
  include_context :server_packages_base
end

shared_context :server_packages_pinned do
  let(:ensure_value) { version }
  include_context :server_packages_base
end

shared_context :server_packages_absent do
  it { should contain_package('pulp-server').with(ensure: 'absent') }
  it { should contain_package('pulp-puppet-plugins').with(ensure: 'absent') }
  it { should contain_package('pulp-puppet-plugins').with(ensure: 'absent') }
  it { should contain_package('pulp-rpm-plugins').with(ensure: 'absent') }
  it { should contain_package('pulp-selinux').with(ensure: 'absent') }
end
