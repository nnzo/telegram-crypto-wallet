require 'telegram/bot'
require 'sequel'
require 'mysql2'
require 'yaml'
require_relative 'commands/createwallet.rb'
require_relative 'commands/address.rb'
require 'net/http'
require 'uri'
require 'json'
require_relative 'rpc.rb'

@conf = YAML::load_file(File.join(__dir__, '../config.yaml')); puts "Loaded config"
db = Sequel.connect(@conf['db'])
class Wallets < Sequel::Model; end
puts "Using table " + Wallets.table_name.to_s
$wallets = db[:wallets]


Telegram::Bot::Client.run(@conf['token']) do |bot|
  puts "Started bot"
  bot.listen do |message|
    case message.text
    when '/start'
      if createWalletIfNotExist(bot, message)
        bot.api.send_message(chat_id: message.from.id, text: "Welcome to the #{@conf['coinname']} wallet! Type /address to view your address.")
      else
        bot.api.send_message(chat_id: message.from.id, text: "Welcome to the #{@conf['coinname']} wallet! Type /address to view your address.")
      end
    when '/address'
      if createAddressIfNotExist(bot, message)
        puts "hi"
      else
        puts "hi2"
      end
    end
  end
end