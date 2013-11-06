require 'spec_helper'

shared_context :admin_client_conf_present do
  it do
    should contain_file('/etc/pulp/admin/admin.conf').with_ensure 'present'
  end
end

shared_context :admin_client_conf_absent do
  it do
    should contain_file('/etc/pulp/admin/admin.conf').with_ensure 'absent'
  end
end

shared_context :admin_client_conf_test_template do
  it do
    should contain_file('/etc/pulp/admin/admin.conf').with_content /^This is a test template/
  end
end

shared_context :admin_client_conf_default_template do
  it do
    should contain_file('/etc/pulp/admin/admin.conf').with_content /^host = #{server}/
  end
end
