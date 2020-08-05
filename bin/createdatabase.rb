require 'sequel'
require 'mysql2'
require 'yaml'

@conf = YAML::load_file(File.join(__dir__, '../config.yaml')); puts "Loaded config"

db = Sequel.connect(@conf['db'])

db.create_table :wallets do
  primary_key :id
  BigINT :balance
  String :address
end ; puts "Created table!"