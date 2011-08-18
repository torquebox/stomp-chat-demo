
$( function() {
  client = Stomp.client( "ws://localhost:8675/" )
  client.debug = function(msg) {
    console.debug( msg );
  }

  $( '#chat' ).bind( "submit", function(event) {
    console.debug( "sending something" );
    console.debug( event );
    recipient = $( '#recipient :selected' ).val();
    console.debug( recipient );
    if ( recipient == 'public' ) {
      client.send( '/public', {}, $('#input').val() );
    } else {
      client.send( '/private', { recipient: recipient }, $('#input').val() );
    }
    $( '#input' ).val( '' );
    
    return false;
  } );
  client.connect( null, null, function() {
    $(window).unload(function() {
      client.disconnect();
    });

    $( '#connecting' ).hide();
    $( '#chat-panel' ).show();
    client.subscribe( '/private', function(message) {
        $( '#chat-text' )
          .append( $( '<tr/>' ).addClass( message.headers.sender).addClass( "private" )
            .append( $( '<td class="sender"/>' ).text( message.headers.sender ) )
            .append( $( '<td class="message"/>' ).text( "[PRIVATE] " + message.body ) ) );
    } );
    client.subscribe( '/public', function(message) {
      if ( message.headers.roster ) {
        $('#recipient').children().remove();
        $('#recipient').append( $('<option/>').attr( 'value', 'public' ).text( 'Everyone' ) );
        roster = $.parseJSON( message.body )
        $.each( roster, function(i, each) {
          $('#recipient').append( $('<option/>').attr( 'value', each ).text( each ) );
        } );
      } else {
        $( '#chat-text' )
          .append( $( '<tr/>' ).addClass( message.headers.sender)
            .append( $( '<td class="sender"/>' ).text( message.headers.sender ) ) 
            .append( $( '<td class="message"/>' ).text( message.body ) ) );
      }
    } );
  } );
} )

