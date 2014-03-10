dr-spotify
==========

DR Radio app with Spotify integration

<a href="http://imgur.com/Vy03NZ7"><img src="http://i.imgur.com/Vy03NZ7.png" title="Hosted by imgur.com" /></a>

This app allows you to add the current track of a DR radio channel (Danish Broadcasting Company) to Spotify.

It's just a proof-of-concept for now, so there are some rough edges.

To use:

* get a spotify API key from http://developer.spotify.com and place the appkey.c file in dr-ng/

* change the constant 'SpotifyUsername' in dr-ng/PlayerViewController.m to your Spotify user id.

* create a file, 'spotify_password.txt' with your password (no newline) and place it in dr-ng/

Any track that you add to Spotify from the app will show up in a playlist 'dr-ng' in your Spotify library.

