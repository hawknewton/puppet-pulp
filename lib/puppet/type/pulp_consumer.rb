require 'puppet/type'
require 'uri'

Puppet::Type.newtype(:pulp_consumer) do
  ensurable

  newparam(:id) do
    desc 'The consumer id to register'
    isnamevar
    validate do |v|
      raise 'id may contain only alphanumberic, ., -, and _' unless v =~ /^[A-Za-z0-9\.\-_]+$/
    end
  end

  newproperty(:description)

  newparam(:login)
  newparam(:password)

  newproperty(:notes) do
    validate do |v|
      raise 'notes must be a map' unless v.is_a? Hash
    end
  end

  validate do
    fail 'must specify login' if self[:login].to_s.empty?
    fail 'must specify password' if self[:password].to_s.empty?
  end
end
