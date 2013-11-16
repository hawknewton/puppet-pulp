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

  [ :display_name,
    :description,
    :notes,
    :queries,
    :serve_http,
    :serve_https ].each do |x|
    define_method(x) { @pulp_admin.repos[@resource[:id]].send x }
    define_method("#{x}=") { |v| @pulp_admin.repos[@resource[:id]].send "#{x}=", v }
  end
end
