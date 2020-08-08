require_relative '../rpc.rb'

@conf = YAML::load_file(File.join(__dir__, '../../config.yaml'))
$rpc = DaemonRPC.new(@conf['coindaemon']) # TODO: Make this safer

def getBalanceForUser(userid)
  cbal = $rpc.getbalance(userid.to_s, 12) # Returns balance that has more than 12 confirmations only. (Spendable on the CC network)
  unbal = $rpc.getbalance(userid.to_s, -1) # Returns all balance no matter if they have confirmations or not
  pbal = unbal - cbal
  return cbal, pbal
end
