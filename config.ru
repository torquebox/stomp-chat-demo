
require 'chat_demo'

require 'torquebox-web'
require 'torquebox-stomp'

use TorqueBox::Session::ServletStore
use TorqueBox::Stomp::StompJavascriptClientProvider

run ChatDemo.new

