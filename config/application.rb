# frozen_string_literal: true

require 'pathname'
require 'readline'
require 'fileutils'

require 'bundler/setup'
Bundler.require(:default)

APP_ROOT = Pathname.new(File.expand_path('..', __dir__))
Dir[APP_ROOT.join('app/controllers/**/*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app/models/**/*.rb')].each { |file| require file }
I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]

# Create log directory if it does not exist
log_dir = File.dirname('log/production.log')
FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)
FileUtils.touch(log_dir) unless Dir.exist?(log_dir)
