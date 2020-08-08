# Telegram Crypto Wallet

Simple cryptocurrency wallet for Telegram. Tipping coming soon.

### Prerequisites
* Ruby 2.6.x
* Cryptocurrency daemon
* MySQL installed with a non-root user that has access to a database.

### Setup

1. Make sure to rename your config file from `config.yaml.example` to `config.yaml`

2. Place your telegram token, coin name, coin ticker, address prefix, block explorer link & daemon login in the `config.yaml` file.

3. Make sure you have MySQL installed and a nonroot user created that has access to a database.
You can put your MySQL login details in the `config.yaml` file.

4. Seed the MySQL database by running `ruby bin/createtable.rb` the program will automaticlly read your database/mysql setup from the config file.

5. Run the program: `ruby lib/tcrypto.rb`

### Contributions
Everyone is welcome to contribute to this program. Make changes and open a pull request.

### License
WTFPL (Do What the Fuck You Want To Public License)
