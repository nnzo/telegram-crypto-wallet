require_relative '../rpc.rb'

@conf = YAML::load_file(File.join(__dir__, '../../config.yaml'))

$rpc = DaemonRPC.new(@conf['coindaemon']) # Make this safer

def withdrawHelp(message, bot)
  bot.api.send_message(chat_id: message.from.id, text: "To withdraw you must specify an address or amount. The syntax is:\n\n/withdraw <address> <amount>\n\nExample: /withdraw CJYHqKhtAFrDuhj7DK5T1uwiVTuoQBJP3f 10.1")
end

def withdrawCoins(userid)

end
