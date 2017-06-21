require 'sinatra/base'

module Bot
  class Web < Sinatra::Base
    get '/' do
      'Bots are good for you.'
    end
  end
end
