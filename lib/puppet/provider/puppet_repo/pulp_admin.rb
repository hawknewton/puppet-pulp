require 'puppet-pulp/pulp_admin'

Puppet::Type::type(:puppet_repo).provide(:pulp_admin) do
  def initialize(*args)
    super
    @pulp_admin = PuppetPulp::PulpAdmin.new 'admin', 'admin'
  end

  def create
    @pulp_admin.create @resource[:id], { :display_name => @resource[:display_name] }
  end

  def destroy
    puts "DESTROYING!"
  end

  def exists?
    @pulp_admin.repos.has_key? @resource[:id]
  end

  def display_name
    @pulp_admin.repos[@resource[:id]].display_name
  end

  def display_name=(display_name)
    @pulp_admin.repos[@resource[:id]].display_name = display_name
  end
end
