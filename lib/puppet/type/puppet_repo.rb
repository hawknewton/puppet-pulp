require 'puppet/type'
require 'uri'

Puppet::Type.newtype(:puppet_repo) do
  ensurable

  newparam(:id) do
    desc 'The repo id'
    isnamevar
    validate do |v|
      raise 'name may contain only alphanumberic, ., -, and _' unless v =~ /^[A-Za-z0-9\.\-_]+$/
    end
  end

  newproperty(:display_name)
  newproperty(:description)
  newproperty(:notes) do
    validate do |v|
      raise 'notes must be a map' unless v.is_a? Hash
    end
  end

  newproperty(:queries) do
    munge do |v|
      [v] unless v.is_a? Array
    end
  end

  newproperty(:serve_http) do
    munge do |v|
      v.to_s == 'true'
    end

    validate do |v|
      raise 'serve_http must be a boolean value' unless !!v == v
    end
  end

  newproperty(:serve_https) do
    validate do |v|
      raise 'serve_https must be a boolean value' unless !!v == v
    end
  end

  newproperty(:feed) do
    validate do |v|
      raise 'feed must be a valid url' unless v =~ URI::regexp
    end
  end
end
