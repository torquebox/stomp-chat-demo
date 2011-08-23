
if (!window.TorqueBox) {
  window.TorqueBox = {};
  window.TorqueBox.Events = {};
}

$( function() {
	
  var chatView = new TorqueBox.ChatView();
  chatView.initialize();
	
  var client = Stomp.client(stomp_url);
  client.connect( null, null, function() {
		
    $(TorqueBox.Events).bind('TorqueBox.Chat.Close', function() { client.disconnect });
    $(TorqueBox.Events).bind('TorqueBox.Chat.NewMessage', onNewMessage);

    client.subscribe( '/private', function(message) {
      $(TorqueBox.Events).trigger('TorqueBox.Chat.NewPrivateMessage', [message]);
    } );

    client.subscribe( '/public', function(message) {
      $(TorqueBox.Events).trigger('TorqueBox.Chat.NewPublicMessage', [message]);
    });

    $(TorqueBox.Events).trigger('TorqueBox.Chat.Connect');
  });

  var onNewMessage = function(event, message, recipient) {
    if ( recipient == 'public' ) {
      client.send( '/public', {}, $('#input').val() );
    } else {
      client.send( '/private', { recipient: recipient }, $('#input').val() );
    }
  };

} );

