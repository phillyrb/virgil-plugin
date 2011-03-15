# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugins.delete :rubyforge
Hoe.plugin :git
Hoe.plugin :rcov

spec = Hoe.spec 'metadb_plugin' do
  developer('Erik Hollensbe', 'erik@hollensbe.org')

  self.rubyforge_name = nil
end

desc "install as non-root"
task :install => [:gem] do
  sh "gem install pkg/#{spec.name}-#{spec.version}.gem"
end

# vim: syntax=ruby
