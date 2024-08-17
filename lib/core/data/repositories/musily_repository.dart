import 'dart:async';

import 'package:musily_repository/core/data/datasources/spotify_datasource.dart';
import 'package:musily_repository/core/data/datasources/youtube_datasource.dart';
import 'package:musily_repository/core/domain/datasources/musily_datasource.dart';
import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/repositories/musily_repository.dart'
    as repo;
import 'package:musily_repository/core/domain/entities/album_entity.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/domain/entities/artist_entity.dart';
import 'package:musily_repository/core/domain/entities/home_section_entity.dart';
import 'package:musily_repository/core/domain/entities/playlist_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusilyRepository implements repo.MusilyRepository {
  static final MusilyRepository _instance = MusilyRepository._internal();
  factory MusilyRepository() {
    return _instance;
  }
  MusilyRepository._internal();

  Source source = Source.youtube;
  late final SharedPreferences sharedPreferences;
  late final SpotifyDatasource spotifyDatasource;
  late final YoutubeDatasource youtubeDatasource;
  SpotifyConfig? config;

  Future<void> initialize({SpotifyConfig? spotifyConfig}) async {
    config = spotifyConfig;
    if (config != null) {
      spotifyDatasource = SpotifyDatasource(
        config: config,
      );
    }
    youtubeDatasource = YoutubeDatasource();
    sharedPreferences = await SharedPreferences.getInstance();
    final sourceString = sharedPreferences.getString('source');
    if (sourceString != null) {
      source = Source.values.firstWhere(
        (element) => element.name == sourceString,
      );
    }
    if (config != null) {
      await spotifyDatasource.initialize();
    } else {
      print('sertansdof');
      setDefaultSource(
        Source.youtube,
      );
    }
    await youtubeDatasource.initialize();
  }

  Future<void> login({Source? source}) async {
    if ((source ?? this.source) == Source.spotify) {
      await spotifyDatasource.login();
    }
  }

  MusilyDatasource datasource({Source? source}) {
    if (source == null) {
      return _datasource(this.source);
    } else {
      return _datasource(source);
    }
  }

  MusilyDatasource _datasource(Source source) {
    switch (source) {
      case Source.youtube:
        return youtubeDatasource;
      case Source.spotify:
        return spotifyDatasource;
      default:
        return youtubeDatasource;
    }
  }

  @override
  Future<AlbumEntity?> getAlbum(String albumId, {Source? source}) async {
    final albumDatasource = datasource(source: source);
    return await albumDatasource.getAlbum(albumId);
  }

  @override
  Future<ArtistEntity?> getArtist(String artistId, {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtist(artistId);
  }

  @override
  Future<List<SimplifiedAlbumEntity>> getArtistAlbums(String artistId,
      {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtistAlbums(artistId);
  }

  @override
  Future<List<SimplifiedAlbumEntity>> getArtistSingles(String artistId,
      {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtistSingles(artistId);
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId,
      {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtistTracks(artistId);
  }

  @override
  Future<PlaylistEntity?> getPlaylist(String playlistId,
      {Source? source}) async {
    final playlistDatasource = datasource(source: source);
    return await playlistDatasource.getPlaylist(playlistId);
  }

  @override
  Future<List<PlaylistEntity>> getUserPlaylists({Source? source}) async {
    final playlistDatasource = datasource(source: source);
    return await playlistDatasource.getUserPlaylists();
  }

  @override
  Future<List<TrackEntity>> getRelatedTracks(List<TrackEntity> tracks) async {
    final relatedTracksDatasource = datasource(source: source);
    return await relatedTracksDatasource.getRelatedTracks(tracks);
  }

  @override
  Future<List<String>> getSearchSuggestions(String query,
      {Source? source}) async {
    final suggestionsDatasource = datasource(source: source);
    return await suggestionsDatasource.getSearchSuggestions(query);
  }

  @override
  Future<TrackEntity?> getTrack(String trackId, {Source? source}) async {
    final trackDatasource = datasource(source: source);
    return await trackDatasource.getTrack(trackId);
  }

  @override
  Future<String?> getTrackLyrics(String trackId, {Source? source}) async {
    final lyricsDatasource = datasource(source: source);
    return await lyricsDatasource.getTrackLyrics(trackId);
  }

  @override
  Future<bool> loggedIn({Source? source}) async {
    if (source == null) {
      if (this.source == Source.youtube) {
        return false;
      }
    }
    if (source == Source.youtube) {
      return false;
    } else {
      return spotifyDatasource.loggedIn;
    }
  }

  @override
  Future<List<SimplifiedAlbumEntity>> searchAlbums(String query,
      {Source? source}) async {
    final albumsDatasource = datasource(source: source);
    return await albumsDatasource.searchAlbums(query);
  }

  @override
  Future<List<ArtistEntity>> searchArtists(String query,
      {Source? source}) async {
    final artistsDatasource = datasource(source: source);
    return await artistsDatasource.searchArtists(query);
  }

  @override
  Future<List<HomeSectionEntity>> getHomeSections({Source? source}) async {
    final homeDatasource = datasource(
      source: source,
    );
    return await homeDatasource.getHomeSections();
  }

  @override
  Future<List<TrackEntity>> searchTracks(String query, {Source? source}) async {
    final tracksDatasource = datasource(source: source);
    return await tracksDatasource.searchTracks(query);
  }

  @override
  Future<void> setDefaultSource(Source source) async {
    this.source = source;
    await sharedPreferences.setString('source', source.name);
  }
}
