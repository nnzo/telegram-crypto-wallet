require_relative '../rpc.rb'

@conf = YAML::load_file(File.join(__dir__, '../../config.yaml'))

$rpc = DaemonRPC.new(@conf['coindaemon']) # Make this safer

def withdrawHelp(message, bot)
  bot.api.send_message(chat_id: message.from.id, text: "To withdraw you must specify an address or amount. The syntax is:\n\n/withdraw <address> <amount>\n\nExample: /withdraw CJYHqKhtAFrDuhj7DK5T1uwiVTuoQBJP3f 10.1")
end

def withdrawCoins(userid, amount, bot, address)
  currentbal = $rpc.getbalance(userid.to_s, 12)
  if currentbal < amount # If user is trying to withdraw more than they have
    bot.api.send_message(chat_id: userid, text: "You do not have enough #{@conf['cointicker']} for this transaction. If you just deposited, wait for blockchain confirmations")
  elsif currentbal > amount # If user is trying to withdraw less than their total
    bot.api.send_message(chat_id: userid, text: 'Looks like a valid transaction, broadcasting to network.')
    tx = $rpc.sendfrom(userid.to_s, address, amount)
    bot.api.send_message(chat_id: userid, text: "Transaction sent.\n\n#{amount.to_s.strip} CC was sent to #{address}.\n\nTXID: #{tx.to_s}")
  else
    bot.api.send_message(chat_id: userid, text: "You do not have enough #{@conf['cointicker']} for this transaction. If you just deposited, wait for blockchain confirmations")
  end
end
