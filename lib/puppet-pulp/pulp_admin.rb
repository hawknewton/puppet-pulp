require 'yaml'
require 'ostruct'

module PuppetPulp
  class PulpAdmin
    attr_accessor :login, :password

    def initialize(username, password)
      @username = username
      @password = password
    end

    def create(repo_id, params = {})
      login

      cmd = "pulp-admin puppet repo create --repo-id=\"#{repo_id}\""

      [:display_name,
       :description,
       :serve_http,
       :serve_https].each do |m|
        cmd << " --#{m.to_s.gsub '_', '-'}=\"#{params[m]}\"" unless params[m].nil?
      end

      if params[:queries]
        cmd << " --queries=#{params[:queries].join ','}"
      end

      if params[:notes]
        cmd << " " + params[:notes].keys.sort.map { |k| "--notes \"#{k}=#{params[:notes][k]}\"" }.join(' ')
      end

      output = `#{cmd}`
      raise "Could not create repo: #{output}" unless output =~ /Successfully created repository \[#{repo_id}\]/
    end

    def destroy(repo_id)
      login
      output = `pulp-admin puppet repo delete --repo-id="#{repo_id}"`
      raise "Could not remove repo: #{output}" unless output =~ /Repository \[#{repo_id}\] successfully deleted/
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

        setter = lambda do |val|
          `pulp-admin puppet repo update --repo-id=#{props[:id]} #{val}`
        end

        #getters
        props.each do |k,v|
          singleton_class.send(:define_method, k, lambda { v })
        end

        [:display_name,
         :description,
         :serve_http,
         :serve_https].each do |m|
          singleton_class.send :define_method, "#{m}=" do |v|
            setter.call "--#{m.to_s.gsub('_', '-')}=\"#{v}\""
          end
        end

        singleton_class.send :define_method, :queries= do |arr|
          setter.call "--queries=\"#{arr.join ','}\""
        end

        singleton_class.send :define_method, :notes= do |map|
          notes = []
          map.keys.sort.each do |k|
            notes << "--notes \"#{k}=#{map[k]}\""
          end
          setter.call notes.join ' '
        end

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

    private

    def parse_repos(str)
      repos = str.split /\n\n/

      #Throw away the header
      repos.shift

      #We get extra lines at the end of the input
      repos = repos.reject {|x| x.length == 1 }.map { |x| x.split /\n/ }

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
