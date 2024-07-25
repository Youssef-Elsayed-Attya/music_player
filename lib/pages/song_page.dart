import 'package:flutter/material.dart';
import 'package:music_app/components/neu_box.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  String formatTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    String formattedTime = '${duration.inMinutes}:$twoDigitSeconds';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        //get the playlist
        final playlist = value.playlist;

        // get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        // return scaffold ui
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 25, right: 25),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // app bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // back button
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_rounded)),

                        //title
                        const Text("P L A Y L I S T"),

                        //menu button
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.menu)),
                      ],
                    ),

                    // album artwork

                    NeuBox(
                      size: 50,
                      circle: false,
                      child: Column(
                        children: [
                          //image
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                currentSong.albumArtImagePath,
                                width: width * 0.8,
                                height: height * 0.5,
                              )),

                          // song and artist name
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //song and artist name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.songName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(currentSong.artistName),
                                  ],
                                ),
                                //heart icon

                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    // song duration progress
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // start time
                              Text(formatTime(value.currentDuration)),

                              // shuffle icon
                              const Icon(Icons.shuffle),

                              // repeat time
                              const Icon(Icons.repeat),

                              // end time
                              Text(formatTime(value.totalDuration)),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 0),
                            ),
                            child: Slider(
                              inactiveColor: Colors.grey.shade400,
                              activeColor: const Color(0xffE34715),
                              min: 0,
                              max: value.totalDuration.inSeconds.toDouble(),
                              value: value.currentDuration.inSeconds.toDouble(),
                              onChanged: (double double) {
                                // during when the user is sliding around
                              },
                              onChangeEnd: (double double) {
                                // sliding has finished, go to that position in song duration
                                value.seek(Duration(seconds: double.toInt()));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    // playback controls
                    Row(
                      children: [
                        // skip previous
                        Expanded(
                            child: GestureDetector(
                                onTap: value.playPreviousSong,
                                child: const NeuBox(circle: true,
                                    size: 50 ,
                                    child: Icon(Icons.skip_previous)))),

                        const SizedBox(
                          width: 20,
                        ),

                        //play pause
                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                                onTap: value.pauseOrResume,
                                child: NeuBox(
                                  size: 80,
                                  circle: true,
                                    child: Icon(value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow)))),
                        const SizedBox(
                          width: 20,
                        ),

                        // skip forward
                        Expanded(
                            child: GestureDetector(
                                onTap: value.playNextSong,
                                child: const NeuBox(
                                  size: 50,
                                    circle: true,

                                    child: Icon(Icons.skip_next)))),
                      ],
                    )

                    // NeuBox(
                    //     child: Icon(
                    //   Icons.search,
                    //   size: 100,
                    // ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
