# frozen_string_literal: true

require 'pathname'
require 'readline'

require 'bundler/setup'
Bundler.require(:default)

APP_ROOT = Pathname.new(File.expand_path('..', __dir__))
Dir[APP_ROOT.join('app/controllers/**/*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app/models/**/*.rb')].each { |file| require file }
