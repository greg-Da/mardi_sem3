require 'bundler'
Bundler.require
$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'scrappeur.rb'

Townhall.new.save_as_JSON
Townhall.new.save_as_spreadsheet
Townhall.new.save_as_csv