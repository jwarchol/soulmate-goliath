require 'uri'
require 'json'
require 'redis'
require 'em-synchrony/em-redis'
require 'logger'

require 'soulmate/version'
require 'soulmate/helpers'
require 'soulmate/base'
require 'soulmate/matcher'
require 'soulmate/loader'

module Soulmate

  extend self

  MIN_COMPLETE = 2
  STOP_WORDS = ["vs", "at"]

  def redis=(redis_pool)
    @redis = redis_pool
    redis
  end

  def redis
#puts "New Redis"
    @redis ||= (
      url = URI(@redis_url || "redis://127.0.0.1:6379/0")

      #::Redis.new({
      #  :host => url.host,
      #  :port => url.port,
      #  :db => url.path[1..-1],
      #  :password => url.password
      #})

	EM::Protocols::Redis.connect(:host => url.host, :port => url.port)#, :logger => Logger.new(STDOUT))

    )
  end

end
