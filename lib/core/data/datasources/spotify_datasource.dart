import 'package:dart_spotify_api/dart_spotify_api.dart';
import 'package:musily_repository/core/domain/datasources/musily_datasource.dart';
import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/utils/generate_track_hash.dart';
import 'package:musily_repository/core/data/entities/album_entity_impl.dart';
import 'package:musily_repository/core/data/entities/simplified_album_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/album_entity.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/data/entities/artist_entity_impl.dart';
import 'package:musily_repository/core/data/entities/simplified_artist_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/artist_entity.dart';
import 'package:musily_repository/core/domain/entities/home_section_entity.dart';
import 'package:musily_repository/core/data/entities/playlist_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/playlist_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';

class SpotifyConfig {
  final String clientId;
  final String clientSecret;
  final String redirectUri;
  final String customUriScheme;
  final int? localhostPort;

  SpotifyConfig({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    required this.customUriScheme,
    required this.localhostPort,
  });
}

class SpotifyDatasource implements MusilyDatasource {
  late final SpotifyService spotifyService;
  final Source source = Source.spotify;

  SpotifyDatasource({
    SpotifyConfig? config,
  }) {
    print(config);
    if (config == null) {
      throw Exception('Spotify config has not been provided.');
    }
    spotifyService = SpotifyService(
      clientId: config.clientId,
      clientSecret: config.clientSecret,
      customUriScheme: config.customUriScheme,
      redirectUri: config.redirectUri,
      localhostPort: config.localhostPort,
    );
  }

  Future<void> initialize() async {
    await spotifyService.initialize();
  }

  Future<void> login() async {
    await spotifyService.login();
  }

  bool get loggedIn => spotifyService.loggedIn;

  @override
  Future<AlbumEntity?> getAlbum(String albumId) async {
    final album = await spotifyService.getAlbum(albumId);
    if (album == null) {
      return null;
    }
    final tracks = await spotifyService.getAlbumTracks(albumId);
    return AlbumEntityImpl(
      id: album.id,
      title: album.name,
      artist: SimplifiedArtistEntityImpl(
        id: album.artists.firstOrNull?.id,
        name: album.artists.firstOrNull?.name,
        highResImg: null,
        lowResImg: null,
        source: source,
      ),
      year: album.releaseDate.year,
      lowResImg: album.images.lastOrNull?.url,
      highResImg: album.images.firstOrNull?.url,
      tracks: List<TrackEntity>.from(
        tracks.map(
          (track) => TrackEntity(
            id: track.id,
            hash: generateTrackHash(
              title: track.name,
              artist: track.artists.firstOrNull?.name ?? '',
              albumTitle: album.name,
            ),
            title: track.name,
            artist: SimplifiedArtistEntityImpl(
              id: track.artists.firstOrNull?.id,
              name: track.artists.firstOrNull?.name,
              highResImg: null,
              lowResImg: null,
              source: source,
            ),
            album: SimplifiedAlbumEntityImpl(
              id: album.id,
              title: album.name,
              artist: SimplifiedArtistEntityImpl(
                id: track.artists.firstOrNull?.id,
                name: track.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: null,
              highResImg: null,
              source: source,
            ),
            lowResImg: album.images.lastOrNull?.url,
            highResImg: album.images.firstOrNull?.url,
            source: source,
            lyrics: null,
          ),
        ),
      ),
      source: source,
    );
  }

  @override
  Future<ArtistEntity?> getArtist(String artistId) async {
    final artist = await spotifyService.getArtist(artistId);
    if (artist == null) {
      return null;
    }
    final topTracks = await spotifyService.getTopTracks(artistId);
    final topAlbums = await spotifyService.getTopAlbums(artistId);
    final topSingles = await spotifyService.getTopSingles(artistId);
    final similarArtists = await spotifyService.getSimilarArtists(artistId);

    return ArtistEntityImpl(
      id: artist.id,
      name: artist.name,
      lowResImg: artist.images.lastOrNull?.url,
      highResImg: artist.images.firstOrNull?.url,
      topTracks: topTracks
          .map(
            (track) => TrackEntity(
              id: track.id,
              title: track.name,
              hash: generateTrackHash(
                title: track.name,
                artist: track.artists.firstOrNull?.name ?? '',
                albumTitle: track.album.name,
              ),
              artist: SimplifiedArtistEntityImpl(
                id: track.artists.firstOrNull?.id,
                name: track.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              album: SimplifiedAlbumEntityImpl(
                id: track.album.id,
                title: track.album.name,
                artist: SimplifiedArtistEntityImpl(
                  id: track.artists.firstOrNull?.id,
                  name: track.artists.firstOrNull?.name,
                  highResImg: null,
                  lowResImg: null,
                  source: source,
                ),
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: track.album.images.lastOrNull?.url,
              highResImg: track.album.images.firstOrNull?.url,
              lyrics: null,
              source: source,
            ),
          )
          .toList(),
      topAlbums: topAlbums
          .map(
            (album) => SimplifiedAlbumEntityImpl(
              id: album.id,
              title: album.name,
              artist: SimplifiedArtistEntityImpl(
                id: album.artists.firstOrNull?.id,
                name: album.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: album.images.lastOrNull?.url,
              highResImg: album.images.firstOrNull?.url,
              source: source,
            ),
          )
          .toList(),
      topSingles: topSingles
          .map(
            (single) => SimplifiedAlbumEntityImpl(
              id: single.id,
              title: single.name,
              artist: SimplifiedArtistEntityImpl(
                id: single.artists.firstOrNull?.id,
                name: single.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: single.images.lastOrNull?.url,
              highResImg: single.images.firstOrNull?.url,
              source: source,
            ),
          )
          .toList(),
      similarArtists: similarArtists
          .map(
            (similarArtist) => ArtistEntityImpl(
              id: similarArtist.id,
              name: similarArtist.name,
              lowResImg: similarArtist.images.lastOrNull?.url,
              highResImg: similarArtist.images.firstOrNull?.url,
              source: source,
              topTracks: [],
              topAlbums: [],
              topSingles: [],
              similarArtists: [],
            ),
          )
          .toList(),
      source: source,
    );
  }

  @override
  Future<List<SimplifiedAlbumEntity>> getArtistAlbums(String artistId) async {
    final albums = await spotifyService.getTopAlbums(artistId);
    return albums
        .map((album) => SimplifiedAlbumEntityImpl(
              id: album.id,
              title: album.name,
              artist: SimplifiedArtistEntityImpl(
                id: album.artists.firstOrNull?.id,
                name: album.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: album.images.lastOrNull?.url,
              highResImg: album.images.firstOrNull?.url,
              source: source,
            ))
        .toList();
  }

  @override
  Future<List<SimplifiedAlbumEntity>> getArtistSingles(String artistId) async {
    final singles = await spotifyService.getTopSingles(artistId);
    return singles
        .map((single) => SimplifiedAlbumEntityImpl(
              id: single.id,
              title: single.name,
              artist: SimplifiedArtistEntityImpl(
                id: single.artists.firstOrNull?.id,
                name: single.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: single.images.lastOrNull?.url,
              highResImg: single.images.firstOrNull?.url,
              source: source,
            ))
        .toList();
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    final topTracks = await spotifyService.getTopTracks(artistId);
    return topTracks
        .map((track) => TrackEntity(
              id: track.id,
              title: track.name,
              hash: generateTrackHash(
                title: track.name,
                artist: track.artists.firstOrNull?.name ?? '',
                albumTitle: track.album.name,
              ),
              artist: SimplifiedArtistEntityImpl(
                id: track.artists.firstOrNull?.id,
                name: track.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              album: SimplifiedAlbumEntityImpl(
                id: track.album.id,
                title: track.album.name,
                artist: SimplifiedArtistEntityImpl(
                  id: track.artists.firstOrNull?.id,
                  name: track.artists.firstOrNull?.name,
                  highResImg: null,
                  lowResImg: null,
                  source: source,
                ),
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: track.album.images.lastOrNull?.url,
              highResImg: track.album.images.firstOrNull?.url,
              lyrics: null,
              source: source,
            ))
        .toList();
  }

  @override
  Future<List<HomeSectionEntity>> getHomeSections() async {
    return [];
  }

  @override
  Future<PlaylistEntity?> getPlaylist(String playlistId) async {
    final playlist = await spotifyService.getPlaylist(playlistId);
    if (playlist == null) {
      return null;
    }
    return PlaylistEntityImpl(
      id: playlist.id,
      title: playlist.name,
      artist: SimplifiedArtistEntityImpl(
        id: playlist.owner.id,
        name: playlist.owner.name,
        highResImg: null,
        lowResImg: null,
        source: source,
      ),
      lowResImg: playlist.images.lastOrNull?.url,
      highResImg: playlist.images.firstOrNull?.url,
      tracks: playlist.tracks
          .map((track) => TrackEntity(
                id: track.id,
                title: track.name,
                hash: generateTrackHash(
                  title: track.name,
                  artist: track.artists.firstOrNull?.name ?? '',
                  albumTitle: track.album.name,
                ),
                artist: SimplifiedArtistEntityImpl(
                  id: track.artists.firstOrNull?.id,
                  name: track.artists.firstOrNull?.name,
                  highResImg: null,
                  lowResImg: null,
                  source: source,
                ),
                album: SimplifiedAlbumEntityImpl(
                  id: track.album.id,
                  title: track.album.name,
                  artist: SimplifiedArtistEntityImpl(
                    id: track.artists.firstOrNull?.id,
                    name: track.artists.firstOrNull?.name,
                    highResImg: null,
                    lowResImg: null,
                    source: source,
                  ),
                  highResImg: null,
                  lowResImg: null,
                  source: source,
                ),
                lowResImg: track.album.images.lastOrNull?.url,
                highResImg: track.album.images.firstOrNull?.url,
                source: source,
                lyrics: null,
              ))
          .toList(),
      source: source,
    );
  }

  @override
  Future<List<PlaylistEntity>> getUserPlaylists() async {
    final playlists = await spotifyService.getUserPlaylists();
    return playlists
        .map(
          (playlist) => PlaylistEntityImpl(
            id: playlist.id,
            title: playlist.name,
            artist: SimplifiedArtistEntityImpl(
              id: playlist.owner.id,
              name: playlist.owner.name,
              highResImg: null,
              lowResImg: null,
              source: source,
            ),
            lowResImg: playlist.images.lastOrNull?.url,
            highResImg: playlist.images.firstOrNull?.url,
            tracks: [],
            source: source,
          ),
        )
        .toList();
  }

  @override
  Future<List<TrackEntity>> getRelatedTracks(List<TrackEntity> tracks) async {
    return [];
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    final results =
        await spotifyService.search(query, type: [SearchType.track]);
    return results.whereType<TrackModel>().map((track) => track.name).toList();
  }

  @override
  Future<TrackEntity?> getTrack(String trackId) async {
    final track = await spotifyService.getTrack(trackId);
    if (track == null) {
      return null;
    }
    return TrackEntity(
      id: track.id,
      hash: generateTrackHash(
        title: track.name,
        artist: track.artists.firstOrNull?.name ?? '',
        albumTitle: track.album.name,
      ),
      title: track.name,
      artist: SimplifiedArtistEntityImpl(
        id: track.artists.firstOrNull?.id,
        name: track.artists.firstOrNull?.name,
        highResImg: null,
        lowResImg: null,
        source: source,
      ),
      album: SimplifiedAlbumEntityImpl(
        id: track.album.id,
        title: track.album.name,
        artist: SimplifiedArtistEntityImpl(
          id: track.artists.firstOrNull?.id,
          name: track.artists.firstOrNull?.name,
          highResImg: null,
          lowResImg: null,
          source: source,
        ),
        highResImg: null,
        lowResImg: null,
        source: source,
      ),
      lowResImg: track.album.images.lastOrNull?.url,
      highResImg: track.album.images.firstOrNull?.url,
      source: source,
      lyrics: null,
    );
  }

  @override
  Future<String?> getTrackLyrics(String trackId) async {
    return null;
  }

  @override
  Future<List<SimplifiedAlbumEntity>> searchAlbums(String query) async {
    final albums = await spotifyService.searchAlbums(query);
    print(
      albums.firstOrNull?.images.lastOrNull?.url,
    );
    return albums
        .map(
          (album) => SimplifiedAlbumEntityImpl(
            id: album.id,
            title: album.name,
            artist: SimplifiedArtistEntityImpl(
              id: album.artists.firstOrNull?.id,
              name: album.artists.firstOrNull?.name,
              highResImg: null,
              lowResImg: null,
              source: source,
            ),
            lowResImg: album.images.lastOrNull?.url,
            highResImg: album.images.firstOrNull?.url,
            source: source,
          ),
        )
        .toList();
  }

  @override
  Future<List<ArtistEntity>> searchArtists(String query) async {
    final artists = await spotifyService.searchArtists(query);
    return artists
        .map(
          (artist) => ArtistEntityImpl(
            id: artist.id,
            name: artist.name,
            lowResImg: artist.images.lastOrNull?.url,
            highResImg: artist.images.firstOrNull?.url,
            source: source,
            similarArtists: [],
            topAlbums: [],
            topSingles: [],
            topTracks: [],
          ),
        )
        .toList();
  }

  @override
  Future<List<TrackEntity>> searchTracks(String query) async {
    final tracks = await spotifyService.searchTracks(query);
    return tracks
        .map((track) => TrackEntity(
              id: track.id,
              hash: generateTrackHash(
                title: track.name,
                artist: track.artists.firstOrNull?.name ?? '',
                albumTitle: track.album.name,
              ),
              title: track.name,
              artist: SimplifiedArtistEntityImpl(
                id: track.artists.firstOrNull?.id,
                name: track.artists.firstOrNull?.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              album: SimplifiedAlbumEntityImpl(
                id: track.album.id,
                title: track.album.name,
                artist: SimplifiedArtistEntityImpl(
                  id: track.artists.firstOrNull?.id,
                  name: track.artists.firstOrNull?.name,
                  highResImg: null,
                  lowResImg: null,
                  source: source,
                ),
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: track.album.images.lastOrNull?.url,
              highResImg: track.album.images.firstOrNull?.url,
              lyrics: null,
              source: source,
            ))
        .toList();
  }
}
