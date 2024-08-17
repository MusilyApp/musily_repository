import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:musily_repository/core/domain/datasources/musily_datasource.dart';
import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/utils/generate_section_id.dart';
import 'package:musily_repository/core/utils/generate_track_hash.dart';
import 'package:musily_repository/core/data/entities/album_entity_impl.dart';
import 'package:musily_repository/core/data/entities/simplified_album_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/album_entity.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/data/entities/artist_entity_impl.dart';
import 'package:musily_repository/core/data/entities/simplified_artist_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/artist_entity.dart';
import 'package:musily_repository/core/data/entities/home_section_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/home_section_entity.dart';
import 'package:musily_repository/core/data/entities/playlist_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/playlist_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';

class YoutubeDatasource implements MusilyDatasource {
  final ytMusic = YTMusic();
  final source = Source.youtube;

  Future<void> initialize() async {
    await ytMusic.initialize();
  }

  @override
  Future<AlbumEntity?> getAlbum(String albumId) async {
    final album = await ytMusic.getAlbum(albumId);
    return AlbumEntityImpl(
      id: album.albumId,
      title: album.name,
      artist: SimplifiedArtistEntityImpl(
        id: album.artist.artistId,
        name: album.artist.name,
        highResImg: null,
        lowResImg: null,
        source: source,
      ),
      year: album.year ?? 0,
      lowResImg: album.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
      highResImg: album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
      tracks: List<TrackEntity>.from(
        album.songs.map(
          (track) => TrackEntity(
            id: track.videoId,
            hash: generateTrackHash(
              title: track.name,
              artist: track.artist.name,
              albumTitle: track.album?.name,
            ),
            title: track.name,
            artist: SimplifiedArtistEntityImpl(
              id: track.artist.artistId,
              name: track.artist.name,
              highResImg: null,
              lowResImg: null,
              source: source,
            ),
            album: SimplifiedAlbumEntityImpl(
              id: track.album?.albumId ?? '',
              title: track.album?.name ?? '',
              artist: SimplifiedArtistEntityImpl(
                id: track.artist.artistId,
                name: track.artist.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg: null,
              highResImg: null,
              source: source,
            ),
            lowResImg:
                track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
            highResImg:
                track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
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
    final artist = await ytMusic.getArtist(artistId);
    return ArtistEntityImpl(
      id: artist.artistId,
      name: artist.name,
      lowResImg: artist.thumbnails[0].url.replaceAll('w540-h225', 'w100-h100'),
      highResImg: artist.thumbnails[0].url.replaceAll('w540-h225', 'w600-h600'),
      topTracks: artist.topSongs
          .map(
            (track) => TrackEntity(
              id: track.videoId,
              title: track.name,
              hash: generateTrackHash(
                title: track.name,
                artist: track.artist.name,
                albumTitle: track.album?.name,
              ),
              artist: SimplifiedArtistEntityImpl(
                id: track.artist.artistId,
                name: track.artist.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              album: SimplifiedAlbumEntityImpl(
                id: track.album?.albumId ?? '',
                title: track.album?.name ?? '',
                artist: SimplifiedArtistEntityImpl(
                  id: track.artist.artistId,
                  name: track.artist.name,
                  highResImg: null,
                  lowResImg: null,
                  source: source,
                ),
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg:
                  track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
              highResImg:
                  track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
              lyrics: null,
              source: source,
            ),
          )
          .toList(),
      topAlbums: artist.topAlbums
          .map(
            (album) => SimplifiedAlbumEntityImpl(
              id: album.albumId,
              title: album.name,
              artist: SimplifiedArtistEntityImpl(
                id: album.artist.artistId,
                name: album.artist.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg:
                  album.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
              highResImg:
                  album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
              source: source,
            ),
          )
          .toList(),
      topSingles: artist.topSingles
          .map(
            (single) => SimplifiedAlbumEntityImpl(
              id: single.albumId,
              title: single.name,
              artist: SimplifiedArtistEntityImpl(
                id: single.artist.artistId,
                name: single.artist.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              lowResImg:
                  single.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
              highResImg:
                  single.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
              source: source,
            ),
          )
          .toList(),
      similarArtists: artist.similarArtists
          .map(
            (similarArtist) => ArtistEntityImpl(
              id: similarArtist.artistId,
              name: similarArtist.name,
              lowResImg: similarArtist.thumbnails[0].url
                  .replaceAll('w60-h60', 'w60-h60'),
              highResImg: similarArtist.thumbnails[0].url
                  .replaceAll('w60-h60', 'w600-h600'),
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
  Future<List<SimplifiedAlbumEntity>> getArtistAlbums(
    String artistId,
  ) async {
    final albums = await ytMusic.getArtistAlbums(artistId);
    return albums
        .map(
          (album) => SimplifiedAlbumEntityImpl(
            id: album.albumId,
            title: album.name,
            artist: SimplifiedArtistEntityImpl(
              id: album.artist.artistId,
              name: album.artist.name,
              source: source,
              highResImg: null,
              lowResImg: null,
            ),
            lowResImg: album.thumbnails[0].url.replaceAll('w60-h60', 'w60-h60'),
            highResImg:
                album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
            source: source,
          ),
        )
        .toList();
  }

  @override
  Future<List<SimplifiedAlbumEntity>> getArtistSingles(
    String artistId,
  ) async {
    final singles = await ytMusic.getArtistSingles(artistId);
    return singles
        .map(
          (single) => SimplifiedAlbumEntityImpl(
            id: single.albumId,
            title: single.name,
            artist: SimplifiedArtistEntityImpl(
              id: single.artist.artistId,
              name: single.artist.name,
              source: source,
              highResImg: null,
              lowResImg: null,
            ),
            lowResImg:
                single.thumbnails[0].url.replaceAll('w60-h60', 'w60-h60'),
            highResImg:
                single.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
            source: source,
          ),
        )
        .toList();
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    final tracks = await ytMusic.getArtistSongs(artistId);
    return tracks
        .map(
          (track) => TrackEntity(
            id: track.videoId,
            title: track.name,
            hash: generateTrackHash(
              title: track.name,
              artist: track.artist.name,
              albumTitle: track.album?.name,
            ),
            artist: SimplifiedArtistEntityImpl(
              id: track.artist.artistId,
              name: track.artist.name,
              highResImg: null,
              lowResImg: null,
              source: source,
            ),
            album: SimplifiedAlbumEntityImpl(
              id: track.album?.albumId ?? '',
              title: track.album?.name ?? '',
              artist: SimplifiedArtistEntityImpl(
                id: track.artist.artistId,
                name: track.artist.name,
                highResImg: null,
                lowResImg: null,
                source: source,
              ),
              highResImg: null,
              lowResImg: null,
              source: source,
            ),
            lowResImg:
                track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
            highResImg:
                track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
            lyrics: null,
            source: source,
          ),
        )
        .toList();
  }

  @override
  Future<PlaylistEntity?> getPlaylist(String playlistId) async {
    final playlist = await ytMusic.getPlaylist(playlistId);
    return PlaylistEntityImpl(
      id: playlist.playlistId,
      title: playlist.name,
      artist: SimplifiedArtistEntityImpl(
        id: playlist.artist.artistId,
        name: playlist.artist.name,
        lowResImg: null,
        highResImg: null,
        source: source,
      ),
      tracks: [],
      lowResImg: playlist.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
      highResImg: playlist.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
      source: source,
    );
  }

  @override
  Future<List<PlaylistEntity>> getUserPlaylists() async {
    return [];
  }

  @override
  Future<List<TrackEntity>> getRelatedTracks(List<TrackEntity> tracks) async {
    return [];
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    final suggestions = await ytMusic.getSearchSuggestions(query);
    return suggestions;
  }

  @override
  Future<TrackEntity?> getTrack(String trackId) async {
    final track = await ytMusic.getSong(trackId);
    return TrackEntity(
      id: track.videoId,
      hash: generateTrackHash(
        title: track.name,
        artist: track.artist.name,
      ),
      title: track.name,
      artist: SimplifiedArtistEntityImpl(
        id: track.artist.artistId,
        name: track.artist.name,
        highResImg: null,
        lowResImg: null,
        source: source,
      ),
      album: SimplifiedAlbumEntityImpl(
        id: '',
        title: '',
        artist: SimplifiedArtistEntityImpl(
          id: track.artist.artistId,
          name: track.artist.name,
          highResImg: null,
          lowResImg: null,
          source: source,
        ),
        lowResImg: track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
        highResImg: track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
        source: source,
      ),
      lowResImg: track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
      highResImg: track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
      source: source,
      lyrics: null,
    );
  }

  @override
  Future<String?> getTrackLyrics(String trackId) async {
    final lyrics = await ytMusic.getLyrics(trackId);
    return lyrics;
  }

  @override
  Future<List<SimplifiedAlbumEntity>> searchAlbums(
    String query,
  ) async {
    final albums = await ytMusic.searchAlbums(query);
    return albums.map((album) {
      return SimplifiedAlbumEntityImpl(
        id: album.albumId,
        title: album.name,
        artist: SimplifiedArtistEntityImpl(
          id: album.artist.artistId,
          name: album.artist.name,
          highResImg: null,
          lowResImg: null,
          source: source,
        ),
        lowResImg: album.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
        highResImg: album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
        source: source,
      );
    }).toList();
  }

  @override
  Future<List<ArtistEntity>> searchArtists(
    String query,
  ) async {
    final artists = await ytMusic.searchArtists(query);
    return artists.map((artist) {
      return ArtistEntityImpl(
        id: artist.artistId,
        name: artist.name,
        lowResImg: artist.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
        highResImg: artist.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
        source: source,
        similarArtists: [],
        topAlbums: [],
        topSingles: [],
        topTracks: [],
      );
    }).toList();
  }

  @override
  Future<List<TrackEntity>> searchTracks(String query) async {
    final tracks = await ytMusic.searchSongs(query);
    return tracks.map((track) {
      return TrackEntity(
        id: track.videoId,
        hash: generateTrackHash(
          title: track.name,
          artist: track.artist.name,
          albumTitle: track.album?.name,
        ),
        title: track.name,
        artist: SimplifiedArtistEntityImpl(
          id: track.artist.artistId,
          name: track.artist.name,
          highResImg: null,
          lowResImg: null,
          source: source,
        ),
        album: SimplifiedAlbumEntityImpl(
          id: track.album?.albumId ?? '',
          title: track.album?.name ?? '',
          artist: SimplifiedArtistEntityImpl(
            id: track.artist.artistId,
            name: track.artist.name,
            highResImg: null,
            lowResImg: null,
            source: source,
          ),
          lowResImg: track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
          highResImg:
              track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
          source: source,
        ),
        lowResImg: track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
        highResImg: track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
        source: source,
        lyrics: null,
      );
    }).toList();
  }

  @override
  Future<List<HomeSectionEntity>> getHomeSections() async {
    final homeSections = await ytMusic.getHomeSections();
    return homeSections
        .map(
          (section) => HomeSectionEntityImpl(
            id: generateSectionId(section.title),
            title: section.title,
            content: section.contents.map(
              (content) {
                if (content is AlbumDetailed) {
                  return AlbumEntityImpl(
                    id: content.albumId,
                    title: content.name,
                    year: content.year ?? 0,
                    artist: SimplifiedArtistEntityImpl(
                      id: content.artist.artistId,
                      name: content.artist.name,
                      highResImg: null,
                      lowResImg: null,
                      source: source,
                    ),
                    tracks: [],
                    lowResImg: content.thumbnails[0].url
                        .replaceAll('w60-h60', 'w100-h100'),
                    highResImg: content.thumbnails[0].url
                        .replaceAll('w60-h60', 'w600-h600'),
                    source: source,
                  );
                }
                if (content is PlaylistDetailed) {
                  return PlaylistEntityImpl(
                    id: content.playlistId,
                    title: content.name,
                    artist: SimplifiedArtistEntityImpl(
                      id: content.artist.artistId,
                      name: content.artist.name,
                      source: source,
                      highResImg: null,
                      lowResImg: null,
                    ),
                    tracks: [],
                    lowResImg: content.thumbnails[0].url
                        .replaceAll('w60-h60', 'w100-h100'),
                    highResImg: content.thumbnails[0].url
                        .replaceAll('w60-h60', 'w600-h600'),
                    source: source,
                  );
                }
              },
            ).toList(),
            source: source,
          ),
        )
        .toList();
  }
}
