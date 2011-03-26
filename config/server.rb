config['redis'] = EM::Synchrony::ConnectionPool.new(:size => 20) do
	EM::Protocols::Redis.connect(:host => 'localhost', :port => 6379)
end
