import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/match_sys.dart';
import 'package:random_avatar/random_avatar.dart';
import '../../components/mentee_info.dart';

class ExplorePage extends StatefulWidget {
  final String searchQuery;

  const ExplorePage({super.key, required this.searchQuery});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommended People",
              style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 19),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: MatchSystem.getInterestBasedMatches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No matches found",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final matches = snapshot.data!;

                  // Filter by search query
                  final filteredMatches =
                      matches.where((match) {
                        final name = (match['name'] ?? '').toLowerCase();
                        final category =
                            (match['category'] ?? '').toLowerCase();
                        final query = widget.searchQuery.toLowerCase();
                        return name.contains(query) || category.contains(query);
                      }).toList();

                  if (filteredMatches.isEmpty) {
                    return const Center(
                      child: Text(
                        "No results match your search.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(filteredMatches.length, (index) {
                      final match = filteredMatches[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      MenteeInfo(userId: match['uid']),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                final offsetTween = Tween(
                                  begin: const Offset(0.0, 0.1),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeInOut));
                                final fadeTween = Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                );

                                return SlideTransition(
                                  position: animation.drive(offsetTween),
                                  child: FadeTransition(
                                    opacity: animation.drive(fadeTween),
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[700],
                                  child: ClipOval(
                                    child:
                                        (match['imageUrl'] == null ||
                                                match['imageUrl']
                                                    .toString()
                                                    .isEmpty)
                                            ? RandomAvatar(
                                              match['uid'] ?? match['name'],
                                              width: 80,
                                              height: 80,
                                            )
                                            : Image.network(
                                              match['imageUrl'],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                );
                                              },
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: 30,
                                                );
                                              },
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  match['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Category: ${match['category']}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
