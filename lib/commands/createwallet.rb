def createWalletIfNotExist(bot, message)
  existq = $wallets.where(Sequel[:id] =~ message.from.id)
  case existq.count
  when 0
    $wallets.insert(:id => message.from.id)
    $wallets.where(Sequel[:id] =~ message.from.id).update(balance: 0)
    return true
  when 1
    return false
  else
    puts "Something fucked up"
  end
end