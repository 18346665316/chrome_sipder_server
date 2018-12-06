require 'redis'

$r1 = Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0)
$r2 = Redis.new(:host => '127.0.0.1', :port => 6379, :db => 1)
$r3 = Redis.new(:host => '127.0.0.1', :port => 6379, :db => 2)
$r4 = Redis.new(:host => '127.0.0.1', :port => 6379, :db => 3)

