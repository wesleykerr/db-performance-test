require 'data_mapper'

host = 'localhost'
db   = 'recommender'
user = 'root'
pass = ''

DataMapper.setup(:default, "mysql://#{user}:#{pass}@#{host}/#{db}")

require_relative 'model'

DataMapper.finalize
