
require 'chat_demo'

require 'torquebox-web'
require 'torquebox-stomp'

## Hack
extend TorqueBox::Injectors
inject( '/topics/chat' )
## Hack

use TorqueBox::Session::ServletStore
use TorqueBox::Stomp::StompJavascriptClientProvider

run ChatDemo.new

