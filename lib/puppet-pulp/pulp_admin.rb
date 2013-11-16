require 'yaml'
require 'ostruct'

module PuppetPulp
  class PulpAdmin
    attr_accessor :login, :password

    def initialize(username, password)
      @username = username
      @password = password
    end

    def create(repo_id, params)
      login
      output = `pulp-admin puppet repo create --repo-id="#{repo_id}" --display-name="#{params[:display_name]}"`
      raise "Could not create repo: #{output}" unless output =~ /Successfully created repository \[#{repo_id}\]/
    end

    def repos
      login

      output = `pulp-admin puppet repo list --details`
      # Eat the 4 line header
      body = output.split("\n")[4..-1]

      return {} if body.nil?

      #Split on blank lines between repos
      yamls = body.join("\n").split("\n\n")

      repos = yamls.map do |x|
        y = YAML.load x

        description = y['Description'] == 'None' ? nil : y['Description']
        distributors_config = y['Distributors']['Config']
        importers_config = y['Importers']['Config']
        feed = importers_config['Feed'] unless importers_config.nil?
        notes = y['Notes'].nil? ? { } : y['Notes']

        queries = importers_config && importers_config['Queries'] || ''
        queries = queries.split(/,/).map { |x| x.strip }

        serve_http = distributors_config['Serve Http'] unless distributors_config.nil?
        serve_http ||= true

        serve_https = distributors_config['Serve Https'] unless distributors_config.nil?
        serve_https = serve_https == true ? true : false

        props = {
          :id => y['Id'],
          :display_name => y['Display Name'],
          :description => description,
          :notes => notes,
          :feed => feed,
          :queries => queries,
          :serve_http => serve_http,
          :serve_https => serve_https
        }

        # UGARY -- We might want to be 1.8-able one day
        result = Object.new
        singleton_class = class << result; self end
        props.each do |k,v|
          singleton_class.send(:define_method, k, lambda { v })
        end

        # Looks all busted ghetto, but makes it unimpossible to test
        me = self
        set_display_name = lambda do |display_name|
          me.set_property props[:id], 'display-name', display_name
        end

        singleton_class.send(:define_method, :display_name=, set_display_name)

        result
      end

      repos.inject({}) do |memo,x|
        memo.merge!({x.id => x})
      end
    end

    def login
      unless @logged_in
        output =  `pulp-admin login -u #{@username} -p #{@password}`
        output =~ /Successfully logged in/ || raise("Could not login: #{output}")
      end
      @logged_in = true
    end

    def set_property(id, key, value)
      `pulp-admin puppet repo update --repo-id=#{id} --#{key}=\"#{value}\"`
    end
  end
end
