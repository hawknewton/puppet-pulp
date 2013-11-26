require "#{File.dirname(__FILE__)}/../../../puppet-pulp/pulp_admin"

Puppet::Type::type(:pulp_consumer).provide(:pulp_admin) do
  def create
    pulp_admin.register_consumer @resource[:id], {
      :description => @resource[:description],
      :display_name => @resource[:display_name],
      :notes => @resource[:notes]
    }
  end

  def destroy
    pulp_admin.unregister_consumer @resource[:id]
  end

  def exists?
    consumer = pulp_admin.consumer
    !consumer.nil? && consumer.id == @resource[:id]
  end

  [ :display_name,
    :description,
    :notes ].each do |x|
    define_method(x) { consumer.send x }
    define_method("#{x}=") { |v| consumer.send "#{x}=", v }
  end

  private

  def consumer
    pulp_admin.consumer
  end

  def pulp_admin
    PuppetPulp::PulpAdmin.new @resource[:login], @resource[:password]
  end
end
