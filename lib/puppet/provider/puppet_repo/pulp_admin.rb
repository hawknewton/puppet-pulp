require 'puppet-pulp/pulp_admin'

Puppet::Type::type(:puppet_repo).provide(:pulp_admin) do
  def create
    pulp_admin.create @resource[:id], {
      :display_name => @resource[:display_name],
      :description => @resource[:description],
      :feed => @resource[:feed],
      :notes => @resource[:notes],
      :queries => @resource[:queries],
      :serve_http => @resource[:serve_http],
      :serve_https => @resource[:serve_https]
    }
  end

  def destroy
    pulp_admin.destroy @resource[:id]
  end

  def exists?
    pulp_admin.repos.has_key? @resource[:id]
  end

  [ :display_name,
    :description,
    :feed,
    :notes,
    :queries,
    :serve_http,
    :serve_https ].each do |x|
    define_method(x) { pulp_admin.repos[@resource[:id]].send x }
    define_method("#{x}=") { |v| pulp_admin.repos[@resource[:id]].send "#{x}=", v }
  end

  private

  def pulp_admin
    PuppetPulp::PulpAdmin.new @resource[:login], @resource[:password]
  end
end
