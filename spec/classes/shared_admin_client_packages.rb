require 'spec_helper'

shared_context :admin_client_packages_present do
  it do
    should contain_package('pulp-admin-client')
      .with_ensure 'present'
  end

  it do
    should contain_package('pulp-puppet-admin-extensions')
      .with_ensure 'present'
  end

  it do
    should contain_package('pulp-rpm-admin-extensions')
      .with_ensure 'present'
  end
end

shared_context :admin_client_packages_pinned do
  it do
    should contain_package('pulp-admin-client')
      .with_ensure version
  end

  it do
    should contain_package('pulp-puppet-admin-extensions')
      .with_ensure version
  end

  it do
    should contain_package('pulp-rpm-admin-extensions')
      .with_ensure version
  end
end

shared_context :admin_client_packages_absent do
  it do
    should contain_package('pulp-admin-client')
      .with_ensure 'absent'
  end

  it do
    should contain_package('pulp-puppet-admin-extensions')
      .with_ensure 'absent'
  end

  it do
    should contain_package('pulp-rpm-admin-extensions')
      .with_ensure 'absent'
  end
end
