require 'telegram/bot'
require 'sequel'
require 'mysql2'
require 'yaml'
require 'net/http'
require 'uri'
require 'json'
require_relative 'rpc.rb'

Dir[File.join(__dir__, 'commands', '*.rb')].each { |file| require file }

@conf = YAML::load_file(File.join(__dir__, '../config.yaml')); puts "Loaded config"
db = Sequel.connect(@conf['db'])
class Wallets < Sequel::Model; end
puts "Using table " + Wallets.table_name.to_s
$wallets = db[:wallets]

class String
  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
end

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
      address = createAddressIfNotExist(bot, message)
      bot.api.send_message(chat_id: message.from.id, text: "Your address is:\n\n#{address}")
    when '/balance'
      bal = getBalanceForUser(message.from.id)
      bot.api.send_message(chat_id: message.from.id, text: "Your balance is #{bal} CC")
    when '💵Withdraw💵'
      withdrawHelp(message, bot)
    else
      if message.text.start_with?('/withdraw')
        values = message.text.split(' ')
        if values[1].nil? == false && values[2].nil? == false && values[1].length == 34 && values[1].start_with?('C')
          amount = values[2].to_f if values[2].numeric? #/^\-?[0-9]+$/ =~ values[2]
          # puts amount.class
          # puts amount
          if amount.nil? == false
            puts "1"
          else
            withdrawHelp(message, bot)
          end
        else
          withdrawHelp(message, bot)
        end
      end
    end
  end
end
