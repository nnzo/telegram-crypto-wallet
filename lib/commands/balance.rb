require_relative '../rpc.rb'

@conf = YAML::load_file(File.join(__dir__, '../../config.yaml'))
$rpc = DaemonRPC.new(@conf['coindaemon']) # Make this safer

def getBalanceForUser(userid)
  cbal = $rpc.getbalance(userid.to_s, 12)
  unbal = $rpc.getbalance(userid.to_s, -1)
  pbal = unbal - cbal
  return cbal, pbal
end
