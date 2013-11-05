group :puppet_rspec do
  guard :rspec,
        cmd: 'rake spec_prep;rspec --fail-fast',
        spec_paths: ['spec/classes'],
        all_after_pass: true,
        all_on_start: true,
        focus_on_failed: false do
    watch(%r{^spec/classes/shared_.+\.rb}) { 'spec/classes' }
    watch(%r{^spec/(classes|defines)(/.+_spec\.rb)$}) { |m| "spec/#{m[1]}#{m[2]}" }

    watch('manifests/init.pp')  { |m| 'spec/classes/pulp_spec.rb' }
    watch(%r{manifests/(.+).pp})  { |m| "spec/classes/#{m[1]}_spec.rb" }
#    watch(%r{manifests/(.+).pp})  { |m| "spec/defines/#{m[1]}_spec.rb" }
  end
end
