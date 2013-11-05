require 'spec_helper'

shared_context :pulp_repo_present do
  example do
    should contain_yumrepo('pulp-v2-stable').with({
      baseurl: 'http://repos.fedorapeople.org/repos/pulp/pulp/stable/2/$releasever/$basearch/',
      gpgcheck: '0',
      descr: 'Pulp v2 Production Releases'
    })
  end
end

shared_context :pulp_repo_enabled do
  include_context :pulp_repo_present
  example do
    should contain_yumrepo('pulp-v2-stable').with({
      enabled: '1',
    })
  end
end


shared_context :pulp_repo_disabled do
  include_context :pulp_repo_present

  example do
    should contain_yumrepo('pulp-v2-stable').with({
      enabled: '0',
    })
  end
end


shared_context :pulp_repo_absent do
  example do
    should contain_yumrepo('pulp-v2-stable').with({
      enabled: 'absent',
    })
  end
end
