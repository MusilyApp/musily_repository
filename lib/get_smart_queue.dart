import 'dart:math';

import 'package:musily_repository/get_artist_info.dart';
import 'package:musily_repository/get_artist_songs.dart';

Future<List<Map<String, dynamic>>> getSmartQueue(
  List<Map<String, dynamic>> queue,
) async {
  final List<Map<String, dynamic>> selectedTracks = queue;

  final List<String> artistIds = [
    ...queue.map(
      (track) => track['artist']?['id'] ?? '',
    )
  ];
  final filteredIds = [...artistIds.where((id) => id.isNotEmpty)];
  late final List<String> selectedArtistIds;
  if (filteredIds.length > 3) {
    selectedArtistIds = (filteredIds..shuffle()).sublist(0, 4);
  } else {
    selectedArtistIds = filteredIds;
  }
  for (final artistId in selectedArtistIds) {
    final random = Random();

    final artist = await getArtistInfo(artistId);
    late final String selectedArtistId;

    if (artist['similarArtists'].isNotEmpty) {
      selectedArtistId = artist['similarArtists']
              ?[random.nextInt(artist['similarArtists'].length)]['id'] ??
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
      final selectedTrack = artistTracks[random.nextInt(
        artistTracks.length,
      )];
      if (selectedTracks
          .where((track) => track['hash'] == selectedTrack['hash'])
          .isEmpty) {
        final randomPositon = random.nextInt(selectedTracks.length);
        selectedTracks.insert(
          randomPositon == 0 ? 1 : randomPositon,
          selectedTrack..['fromSmartQueue'] = true,
        );
      }
    }
  }
  return selectedTracks;
}
