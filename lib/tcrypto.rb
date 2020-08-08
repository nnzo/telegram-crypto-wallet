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

mainkb = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(💰Balance💰 📧View Address📧), %w(📥Deposit📥 📤Withdraw📤)])
rkb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
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
        bot.api.send_message(chat_id: message.from.id, text: "Welcome to the #{@conf['coinname']} wallet! Type /address to view your deposit address.", reply_markup: ckbp)
      else
        bot.api.send_message(chat_id: message.from.id, text: "Welcome to the #{@conf['coinname']} wallet! Type /address to view your deposit address.", reply_markup: ckbp)
      end
    when '/address'
      address = createAddressIfNotExist(bot, message)
      bot.api.send_message(chat_id: message.from.id, text: "Your address is:\n\n#{address}")
    when '/deposit'
      address = createAddressIfNotExist(bot, message)
      bot.api.send_message(chat_id: message.from.id, text: "Your address is:\n\n#{address}")
    when '📥Deposit📥'
      address = createAddressIfNotExist(bot, message)
      bot.api.send_message(chat_id: message.from.id, text: "Your deposit address is:\n\n#{address}")
    when '/kb'
      bot.api.send_message(chat_id: message.from.id, text: 'Enabled Keyboard.', reply_markup: mainkb)
    when '/disablekb'
      bot.api.send_message(chat_id: message.from.id, text: 'Disabled Keyboard.', reply_markup: rkb)
    when '/balance'
      bal = getBalanceForUser(message.from.id)[0]
      unbal = getBalanceForUser(message.from.id)[1]
      bot.api.send_message(chat_id: message.from.id, text: "Your confirmed balance: #{bal} #{@conf['cointicker']}\n\nPending balance: #{unbal} #{@conf['tokenticker']}")
    when '💰Balance💰'
      bal = getBalanceForUser(message.from.id)[0]
      unbal = getBalanceForUser(message.from.id)[1]
      bot.api.send_message(chat_id: message.from.id, text: "Your confirmed balance: #{bal} #{@conf['cointicker']}\n\nPending balance: #{unbal} #{@conf['tokenticker']}")
    when '📧View Address📧'
      address = createAddressIfNotExist(bot, message)
      bot.api.send_message(chat_id: message.from.id, text: "Your deposit address is:\n\n#{address}")
    when '📤Withdraw📤'
      withdrawHelp(message, bot)
    else
      if message.text.start_with?('/withdraw')
        values = message.text.split(' ')
        if values[1].nil? == false && values[2].nil? == false && values[1].length == 34 && values[1].start_with?(@conf['addressprefix'])
          amount = values[2].to_f if values[2].numeric? #/^\-?[0-9]+$/ =~ values[2]
          address = values[1]
          if amount.nil? == false
            withdrawCoins(message.from.id, amount, bot, address)
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
