require 'puppet-pulp/pulp_admin'

Puppet::Type::type(:puppet_repo).provide(:puppet_admin) do
  def create
  end

  def destroy
  end

  def exists?
  end

  private
  def repo
  end
end
