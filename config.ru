
require 'chat_demo'

require 'torquebox-web'
require 'torquebox-stomp'

extend TorqueBox::Injectors
inject( '/topics/chat' )

use TorqueBox::Session::ServletStore
use TorqueBox::Stomp::StompJavascriptClientProvider

run ChatDemo.new

