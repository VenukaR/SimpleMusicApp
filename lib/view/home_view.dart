import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_music_player/model/home_view_model.dart';
import 'package:simple_music_player/view/music_player.dart';
import 'package:simple_music_player/widgets/color_extention.dart';
import 'package:simple_music_player/widgets/view_all_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Using GetX for state management, HomeViewModel is injected here
  final homeVM = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the basic structure of the screen, including an app bar and body
      appBar: AppBar(
        backgroundColor: TColor.bg, // Background color for the app bar
        elevation: 0, // Removes the shadow beneath the app bar for a flat look
        title: Text(
          'Music Player', // Title of the app bar
          style: TextStyle(
            color: Colors.white, // White text color
            fontSize: 20, // Font size of the title
            fontWeight: FontWeight.bold, // Bold font weight for the title
          ),
        ),
        centerTitle: true, // Centers the title in the app bar
      ),
      body: Stack(
        children: [
          // Background container with a gradient
          Container(
            decoration: const BoxDecoration(
              // Linear gradient starting from top-left to bottom-right
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 1, 25, 66), Color.fromARGB(255, 157, 2, 246)], // Gradient colors
                begin: Alignment.topLeft, // Start gradient from top-left
                end: Alignment.bottomRight, // End gradient at bottom-right
              ),
            ),
          ),
          // Main content area of the screen is scrollable
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
              children: [
                SizedBox(height: 20), // Adds some space between AppBar and content
                // A section with a title and a 'View All' button (can be expanded for more functionality)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15), // Adds padding on left and right
                  child: ViewAllSection(
                    title: "title", // Placeholder title, you can replace with actual title
                    onPressed: () {}, // Placeholder for button action, no functionality added yet
                  ),
                ),
                SizedBox(height: 5), // Adds some space between sections
                // List of recently played songs, built dynamically using ListView.builder
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disables internal scrolling for this list
                  shrinkWrap: true, // Allows ListView to take up only the space it needs
                  padding: const EdgeInsets.symmetric(horizontal: 15), // Adds horizontal padding
                  itemCount: homeVM.recentlyPlayedArr.length, // Number of items in the list (from ViewModel)
                  itemBuilder: (context, index) {
                    var sObj = homeVM.recentlyPlayedArr[index]; // Fetch song object at the given index
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8), // Adds vertical padding between items
                      child: Card(
                        elevation: 5, // Adds shadow to the card for a raised effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded corners for the card
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10), // Padding inside the ListTile
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Rounded corners for the image
                            child: Image.asset(
                              sObj['image'] as String, // Song cover image
                              width: 60, // Image width
                              height: 60, // Image height
                              fit: BoxFit.cover, // Ensures the image fits within the given dimensions
                            ),
                          ),
                          title: Text(
                            sObj['name'] as String, // Song name
                            style: TextStyle(
                              fontSize: 16, // Font size for the song title
                              fontWeight: FontWeight.bold, // Bold font for song title
                            ),
                          ),
                          subtitle: Text(
                            sObj['artists'] as String, // Artist name
                            style: TextStyle(
                              fontSize: 14, // Font size for artist name
                              color: Colors.grey[600], // Grey color for the subtitle (artist name)
                            ),
                          ),
                          // Play button on the right side of the ListTile
                          trailing: IconButton(
                            icon: Icon(Icons.play_arrow), // Play arrow icon
                            onPressed: () {
                              // Find the index of the selected song from the recently played list
                              int index = homeVM.recentlyPlayedArr.indexWhere((song) =>
                                song['name'] == sObj['name'] &&
                                song['artists'] == sObj['artists'] &&
                                song['audioUrl'] == sObj['audioUrl'] &&
                                song['audioUrl1'] == sObj['audioUrl1'] &&
                                song['image'] == sObj['image']);

                              // Navigate to the MusicPlayerScreen when the play button is pressed
                              Get.to(() => MusicPlayerScreen(
                                // Passing the selected song data to the MusicPlayerScreen
                                song: Song(
                                  title: sObj['name'] as String, // Song title
                                  artist: sObj['artists'] as String, // Song artist
                                  path1: sObj['audioUrl'] as String, // Song audio URL
                                  imagePath: sObj['image'] as String, // Song cover image URL
                                ),
                                // Pass the entire recently played list to the player for navigation
                                allSongs: homeVM.recentlyPlayedArr.map((song) {
                                  print("Creating song with title: ${song['name']} and path: ${song['audioUrl']}");
                                  return Song(
                                    title: song['name'] as String, // Song title
                                    artist: song['artists'] as String, // Song artist
                                    path1: song['audioUrl'] as String, // Song audio URL
                                    imagePath: song['image'] as String, // Song cover image URL
                                  );
                                }).toList(),
                                currentIndex: index, // Currently selected song index
                              ));
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
