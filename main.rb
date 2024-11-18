# frozen_string_literal: true
require_relative 'config/application'
Dotenv.load
ApplicationController.new.run