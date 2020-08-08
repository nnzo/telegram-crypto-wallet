# Return codes:
# 1; Account did not exist, but was created
# 2; Account & address existed, sending address to user
# 3; Account existed, but there was no address. An address was assigned to the account.
@conf = YAML::load_file(File.join(__dir__, '../../config.yaml'))
require_relative '../rpc.rb'

$rpc = DaemonRPC.new(@conf['coindaemon']) # Make this safer

def createAddressIfNotExist(bot, message)
  address = Wallets[message.from.id]
  if address.nil? # Account hasn't even been created
    createWalletIfNotExist(bot, message) # Create it
    addr = $rpc.getaccountaddress(message.from.id.to_s)
    $wallets.where(Sequel[:id] =~ message.from.id).update(address: addr)
    return addr
  end
  if address[:address].nil? # There is a account, but no address. Let's create one.
    addr = $rpc.getaccountaddress(message.from.id.to_s)
    $wallets.where(Sequel[:id] =~ message.from.id).update(address: addr)
    return addr
  else
    return address.address
  end
end


def fetchAddress(bot, message)

end
