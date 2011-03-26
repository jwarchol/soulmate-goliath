#!/usr/bin/env ruby
require 'rubygems'
require 'json'

i = 1
File.foreach("/usr/share/dict/words") do |word|
	entry = {}
	entry['id'] = i
	entry['term'] = word.strip
	entry['score'] = 85

	puts entry.to_json

	i += 1
end
