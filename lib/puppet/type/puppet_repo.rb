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
    queries = []
    munge do |v|
      queries << v
    end
  end

  newproperty(:schedules) do
    schedules = []
    munge do |v|
      schedules << v
    end
  end


  newproperty(:serve_http) do
    munge do |v|
      v.to_s == 'true'
    end

    validate do |v|
      raise 'serve_http must be a boolean value' unless (['true', 'false'] & [v.to_s]).any?
    end
  end

  newproperty(:serve_https) do
    munge do |v|
      v.to_s == 'true'
    end

    validate do |v|
      raise 'serve_https must be a boolean value' unless (['true', 'false'] & [v.to_s]).any?
    end
  end

  newproperty(:feed) do
    validate do |v|
      raise 'feed must be a valid url' unless v =~ URI::regexp
    end
  end

   newparam(:login)
   newparam(:password)

  validate do
    fail 'must specify login' if self[:login].to_s.empty?
    fail 'must specify password' if self[:password].to_s.empty?
  end
end
