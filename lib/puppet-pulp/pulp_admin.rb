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
      repos = parse_repos(output).map do |repo|
        description = repo['Description'] == 'None' ? nil : repo['Description']
        distributors_config = repo['Distributors']['Config']
        importers_config = repo['Importers']['Config']
        feed = importers_config['Feed'] unless importers_config.nil?
        notes = repo['Notes'].nil? ? { } : repo['Notes']

        queries = importers_config && importers_config['Queries'] || ''
        queries = queries.split(/,/).map { |x| x.strip }

        serve_http = distributors_config['Serve Http'] unless distributors_config.nil?
        serve_http = serve_http.is_a?(String) ? serve_http == 'True' : true

        serve_https = distributors_config['Serve Https'] unless distributors_config.nil?
        serve_https = serve_https == 'True'

        props = {
          :id => repo['Id'],
          :display_name => repo['Display Name'],
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

    private

    def parse_repos(str)
      repos = str.split /\n\n/

      #Throw away the header
      repos.shift

      repos = repos.map { |x| x.split /\n/ }
      repos.map { |x| parse_lines x }
    end

    def parse_lines(lines, indent = '')
      result = {}
      while lines && line = lines.shift
        if line =~ /^#{indent}([^\s][^:]+):(.*)$/
          value = $2.strip
          if value.empty?
            value = parse_lines(lines, "#{indent}  ")
          end
          result[$1] = value
        else
          lines.unshift line
          break
        end
      end
      result.empty? ? nil : result
    end
  end
end
