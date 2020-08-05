require 'telegram/bot'
require 'sequel'
require 'mysql2'
require 'yaml'
require_relative 'commands/createwallet.rb'

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
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end