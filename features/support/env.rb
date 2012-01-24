require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'mail-test'

require 'test/unit/assertions'

World(Test::Unit::Assertions)

require 'net/smtp'
require 'net/imap'
require 'timeout'
require 'uuid'

def uuid
	UUID.new.generate
end

