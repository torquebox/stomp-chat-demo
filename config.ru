
require 'torquebox-web'
require 'torquebox-stomp'
require 'chat_demo'

use TorqueBox::Session::ServletStore
use TorqueBox::Stomp::StompJavascriptClientProvider

run ChatDemo.new

