# Returns a slack attachment for the track passed
module.exports = (room, track) ->
  return {
    channel: room,
    text: "Now playing *" + track.name + "* by *" + track.artists[0].name + "*",
    attachments: [{
      fallback: "Now playing " + track.name + " by " + track.artists[0].name,
      # author_name: "Spotify Player",
      # author_icon: "http://megaicons.net/static/img/icons_sizes/44/116/512/app-spotify-icon.png",
      title: track.name + " by " + track.artists[0].name,
      # title_link: track.external_urls.spotify,
      text: track.album.name + "\n <" + track.external_urls.spotify + "|View on Spotify>",
      thumb_url: track.album.images[0].url,
    }]
  };
