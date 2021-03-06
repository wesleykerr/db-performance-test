require 'dm-core'
require 'dm-migrations'

class Model
  include DataMapper::Resource
  
  property :appid,          Integer, :key => true, :min => 0, :max => 2**64-1
  property :model_column,   Text

end
