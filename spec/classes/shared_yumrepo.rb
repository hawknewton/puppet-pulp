shared_context :yumrepo_present do
  it do
    should contain_yumrepo('pulp-v2-stable').with({
      :baseurl  => 'http://repos.fedorapeople.org/repos/pulp/pulp/stable/2/$releasever/$basearch/',
      :gpgcheck => '0',
      :descr    => 'Pulp v2 Production Releases'
    })
  end
end

shared_context :yumrepo_enabled do
  include_context :yumrepo_present
  it do
    should contain_yumrepo('pulp-v2-stable').with({
      :enabled => '1',
    })
  end
end


shared_context :yumrepo_disabled do
  include_context :yumrepo_present
  it do
    should contain_yumrepo('pulp-v2-stable').with({
      :enabled => '0',
    })
  end
end


shared_context :yumrepo_absent do
  it do
    should contain_yumrepo('pulp-v2-stable').with({
      :enabled => 'absent'
    })
  end
end
