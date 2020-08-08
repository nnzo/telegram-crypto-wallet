require_relative '../rpc.rb'

@conf = YAML::load_file(File.join(__dir__, '../../config.yaml'))
$rpc = DaemonRPC.new(@conf['coindaemon']) # Make this safer

def getBalanceForUser(userid)
  bal = $rpc.getbalance(userid.to_s)
  return bal
end
