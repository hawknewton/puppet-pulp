require 'yaml'
require 'ostruct'

module PuppetPulp
  class PuppetAdmin
    attr_accessor :login, :password

    def initialize(login, pasword)
      @login = login
      @password = password
    end

    def repos
      login

      output = `pulp-admin puppet repo list --details`
      # Eat the 4 line header
      output = output.split("\n")[4..-1].join "\n"

      #Split on blank lines between repos
      yamls = output.split("\n\n")

      yamls.map do |x|
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


        serve_https
        result = OpenStruct.new({
          id: y['Id'],
          display_name: y['Display Name'],
          description: description,
          notes: notes,
          feed: feed,
          queries: queries,
          serve_http: serve_http,
          serve_https: serve_https
        })
      end
    end

    def login
      unless @logged_in
        output =  `pulp-admin login -u test-login -p test-password`
        output =~ /Successfully logged in/ || raise("Could not login: #{output}")
      end
      @logged_in = true
    end
  end
end
