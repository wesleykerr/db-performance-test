require 'redis'
require 'memcached'
require 'logger'
require_relative 'models/init'

class Loader 

  def initialize
    @log = Logger.new(STDOUT)
  end

  def loadMatrix(matrixFile)
    @log.info { "loading matrix beginning" } 
    File.open(matrixFile, 'r') do |file_io|
      items = file_io.readline().split(',')
      items.shift
      @log.info { "...#{items.length} items" }
      
      columnMap = {}
      items.each { |item| columnMap[item] = [] } 
      
      file_io.each_line do |line|
        scores = line.split(',')
        scores.shift
        scores.each_with_index do |score,idx| 
          item = items[idx]
          columnMap[item] << score
        end
      end
      @log.info { "reading matrix finished" }
      #addToRedis(items, columnMap)
      #addToMySQL(items, columnMap)
      addToMemcached(items, columnMap)
    end
    @log.info { "loading matrix finished" }
  end

  private 
  def addToRedis(items, columnMap)
    beginTime = Time.now
    @redis = Redis.new(:host => "localhost", :port => 6379)
    @redis.pipelined do
      items.each do |item|
        @redis.set(item,columnMap[item].join(','))
      end
    end
    endTime = Time.now
    @log.info { "Loaded all columns into redis in #{(endTime - beginTime)} seconds" }
  end

  def addToMySQL(items, columnMap)
    beginTime = Time.now
    items.each do |item|
      Model.create(:appid => item, :model_column => columnMap[item].join(','))  
    end
    endTime = Time.now
    @log.info { "Loaded all columns into MySQL in #{(endTime - beginTime)} seconds" }
  end

  def addToMemcached(items, columnMap)
    beginTime = Time.now
    cache = Memcached.new('localhost:11211', :no_block=>true, :buffer_requests=>true, :noreply=>true, :binary_protocol=>false)
    items.each do |item|
      cache.set(item.chomp, columnMap[item].join(','))  
    end
    endTime = Time.now
    @log.info { "Loaded all columns into Memcached in #{(endTime - beginTime)} seconds" }
  end
end

loader = Loader.new
loader.loadMatrix('../data/heats.csv')


