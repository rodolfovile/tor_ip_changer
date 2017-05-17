require 'net/http'
require 'uri'
require 'net/telnet'
require 'mechanize'
require 'socksify'

$PORT = 9050
$HOST = '127.0.0.1'
$URL = 'https://api.ipify.org'

#this needed cause, tor coonect with Telnet
puts "Type the command bellow: \n tor --CookieAuthentication 0 --HashedControlPassword "" --ControlPort 9050 --SocksPort 50001"

puts "How many time do want to change the IP addrs:  "
times_change = gets.to_i

def current_ip()
  original_ip = Mechanize.new.get($URL).content
  puts "ATUAL IP IS [+][+] #{original_ip} [+][+]"
  TCPSocket::socks_server = "127.0.0.1"
  TCPSocket::socks_port = "50001"
  $PORT  = 9050
  switch_endpoint()
end

def switch_endpoint
  2.times do
    #Switch IP
    localhost = Net::Telnet::new("Host" => "localhost", "Port" => "#{$PORT}", "Timeout" => 10, "Prompt" => /250 OK\n/)
    localhost.cmd('AUTHENTICATE ""') { |c| print c; throw "Cannot authenticate to Tor" if c != "250 OK\n" }
    localhost.cmd('signal NEWNYM') { |c| print c; throw "Cannot switch Tor to new route" if c != "250 OK\n" }
    localhost.close
  sleep 5

  new_ip = Mechanize.new.get($URL).content
  puts "NEW IP IS [+][+] #{new_ip} [+][+]"
end
end


i = 0
while i < times_change
current_ip()
i = i + 1
end
