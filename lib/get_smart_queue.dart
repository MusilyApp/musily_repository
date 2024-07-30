import 'dart:math';

import 'package:musily_repository/get_artist_info.dart';
import 'package:musily_repository/get_artist_songs.dart';

Future<List<Map<String, dynamic>>> getSmartQueue(
  List<Map<String, dynamic>> queue,
) async {
  final List<Map<String, dynamic>> selectedTracks = [...queue];

  if (queue.length == 1) {
    final artistId = queue[0]['artist']?['id'] ?? '';
    if (artistId.isEmpty) return selectedTracks;

    final artist = await getArtistInfo(artistId);
    final List<dynamic> similarArtists = artist['similarArtists'] ?? [];

    late final List<String> selectedArtistIds;

    if (similarArtists.isEmpty) {
      selectedArtistIds = [artistId];
    } else if (similarArtists.length <= 3) {
      selectedArtistIds =
          similarArtists.map<String>((a) => a['id'] ?? '').toList();
    } else {
      selectedArtistIds =
          (similarArtists.map<String>((a) => a['id'] ?? '').toList()..shuffle())
              .sublist(0, 3);
    }

    for (final selectedArtistId in selectedArtistIds) {
      final artistTracks = await getArtistTracks(selectedArtistId);
      final random = Random();
      final trackQuantity = random.nextInt(3);

      if (artistTracks.isEmpty) continue;

      for (int i = 0; i < (trackQuantity == 0 ? 1 : trackQuantity); i++) {
        final selectedTrack = artistTracks[random.nextInt(artistTracks.length)];
        if (selectedTracks
            .where((track) => track['hash'] == selectedTrack['hash'])
            .isEmpty) {
          final randomPosition = random.nextInt(selectedTracks.length);
          selectedTracks.insert(
            randomPosition == 0 ? 1 : randomPosition,
            {...selectedTrack, 'fromSmartQueue': true},
          );
        }
      }
    }
  } else if (queue.length > 1) {
    final List<String> artistIds = queue
        .map<String>((track) => track['artist']?['id'] ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    late final List<String> selectedArtistIds;
    if (artistIds.length > 3) {
      selectedArtistIds = (artistIds..shuffle()).sublist(0, 4);
    } else {
      selectedArtistIds = artistIds;
    }

    for (final artistId in selectedArtistIds) {
      final random = Random();
      final artist = await getArtistInfo(artistId);
      late final String selectedArtistId;

      if (artist['similarArtists'].isNotEmpty) {
        selectedArtistId = artist['similarArtists']
                [random.nextInt(artist['similarArtists'].length)]['id'] ??
            artistId;
      } else {
        selectedArtistId = artistId;
      }

      final artistTracks = await getArtistTracks(selectedArtistId);
      final trackQuantity = random.nextInt(3);

      if (artistTracks.isEmpty) {
        continue;
      }

      for (int i = 0; i < (trackQuantity == 0 ? 1 : trackQuantity); i++) {
        final selectedTrack = artistTracks[random.nextInt(artistTracks.length)];
        if (selectedTracks
            .where((track) => track['hash'] == selectedTrack['hash'])
            .isEmpty) {
          final randomPosition = random.nextInt(selectedTracks.length);
          selectedTracks.insert(
            randomPosition == 0 ? 1 : randomPosition,
            {...selectedTrack, 'fromSmartQueue': true},
          );
        }
      }
    }
  }

  return selectedTracks;
}
