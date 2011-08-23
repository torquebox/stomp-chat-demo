
if (!window.TorqueBox) {
  window.TorqueBox = {};
  window.TorqueBox.Events = {};
}

TorqueBox.ChatView = function() {
  
  this.initialize = function() {
    
    $(TorqueBox.Events).bind('TorqueBox.Chat.NewPublicMessage', onPublicMessageUpdate);
    $(TorqueBox.Events).bind('TorqueBox.Chat.NewPrivateMessage', onPrivateMessageUpdate);
    $(TorqueBox.Events).bind('TorqueBox.Chat.Connect', onChatConnect);
    
    $( '.chat-window' ).height( $(window).height() - 80 );
    $( '.recipient' ).live( 'click', onClick);
    $( '#recipient-public' ).click();
    $( '#chat-form' ).bind( "submit", onMessageSubmit);
    
      $(window).unload(function() {
        $(TorqueBox.Events).trigger('TorqueBox.Chat.Close');
      });
  
    $( "input:submit" ).button();
  };
  
  var onClick = function(event) {
      recipient = $(this).attr( 'recipient' );
      recipient_window = $( '#chat-window-' + recipient );
      if ( recipient_window.size() == 0 ) {
        recipient_window = $( '<div/>' ).addClass( 'chat-window' ).attr( 'id', 'chat-window-' + recipient );
        recipient_window.height( $(window).height() - 80 );
        $( '#chat-windows' ).append( recipient_window );
      }

      $( '.chat-window' ).hide();
      $( '#chat-window-' + recipient ).show();
      $( '.recipient' ).removeClass( 'current' );
      $( this ).addClass( 'current' );
      $( this ).removeClass( 'unread' );
  };
  
  var onChatConnect = function() {
    $( '#connecting' ).hide();
    $( '#chat-panel' ).show();
  };
  
  var onPublicMessageUpdate = function(event, message) {
      if ( message.headers.roster ) {
      current_recipient = $( '.recipient.current' ).attr( 'recipient' );
      $('#recipient').children().remove();
      $('#recipient').append( $('<div/>').attr( 'id', 'recipient-system' ).addClass( 'recipient' ).attr( 'recipient', 'system' ).text( 'System' ) );
      $('#recipient').append( $('<div/>').attr( 'id', 'recipient-public' ).addClass( 'recipient' ).attr( 'recipient', 'public' ).text( 'Everyone' ) );
      roster = $.parseJSON( message.body )
      $.each( roster, function(i, each) {
        $('#recipient').append( $('<div/>').attr( 'id', 'recipient-' + each ).addClass( 'recipient' ).attr( 'recipient', each ).text( each ) );
      } );
      new_current_recipient  = $( '#recipient-' + current_recipient );
      if ( new_current_recipient.size() == 0 ) {
        new_current_recipient.click();
      } else {
        $( '#recipient-public' ).click();
      }
      $( '#recipient-' + username ).addClass( 'self' );
      } else {
      shouldScroll = false;
      current_recipient = $( '.recipient.current' ).attr( 'recipient' );
      if ( current_recipient != 'public' ) {
        $( '#recipient-public' ).addClass( 'unread' );
      } else {
        h = $( '#chat-window-public' ).height();
        st = $( '#chat-window-public' ).scrollTop();
        sh = $( '#chat-window-public' ).attr( 'scrollHeight' );
        if ( ( st + h ) == sh ) {
          shouldScroll = true;
        }
          }

      $( '#chat-window-public' )
        .append( $( '<div/>' ).addClass( 'message' ).addClass( message.headers.sender )
          .append( $( '<span/>' ).addClass( 'sender' ).text( message.headers.sender ) ) 
          .append( $( '<span/>' ).addClass( 'text' ).text( message.body ) ) );

      if ( shouldScroll ) {
        $( '#chat-window-public' ).animate({ scrollTop: $( '#chat-window-public' ).attr( 'scrollHeight' ) } );
      }
      }
  };
  
  var onPrivateMessageUpdate = function(event, message) {
    
    sender = message.headers.sender;
    recipient = message.headers.recipient;

    effective_user = sender == username ? recipient : sender;
      effective_window = $( '#chat-window-' + effective_user );
      if ( effective_window.size() == 0 ) {
        effective_window = $( '<div/>' ).addClass( 'chat-window' ).attr( 'id', 'chat-window-' + effective_user );
        $( '#chat-windows' ).append( effective_window );
        effective_window.hide();
        effective_window.height( $(window).height() - 80 );
      }

      effective_window
        .append( $( '<div/>' ).addClass( 'message' ).addClass( effective_user )
          .append( $( '<span/>' ).addClass( 'sender' ).text( sender ) ) 
          .append( $( '<span/>' ).addClass( 'text' ).text( message.body ) ) );

      current_recipient = $( '.recipient.current' ).attr( 'recipient' );

      if ( current_recipient != effective_user ) {
        $( '#recipient-' + effective ).addClass( 'unread' );
      };  
  };
  
  var onMessageSubmit = function(event) {
    recipient = $( '.recipient.current' ).attr( 'recipient' );
    $(TorqueBox.Events).trigger('TorqueBox.Chat.NewMessage', [$('#input').val(), recipient]);
    $( '#input' ).val( '' );
    return false;
  };
  
};
