def createAddressIfNotExist(bot, message)
  address = Wallets[message.from.id]
  if address[:address].nil?
    rpc = DaemonRPC.new(@conf['coindaemon'])
  else
    return false
  end
end
def fetchAddress(bot, message)

end