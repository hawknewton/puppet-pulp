require 'spec_helper_system'

describe 'puppet repo type' do

  before do
    manifest = %q{
      class {'pulp': }
      class {'pulp::server': }
      class {'pulp::admin_client': }
    }

    puppet_apply manifest
  end

  it 'should create repos' do
    manifest = %q{
      puppet_repo { 'test-repo-id':
        display_name => 'test display name'
      }
    }

    puppet_apply manifest
  end
end
