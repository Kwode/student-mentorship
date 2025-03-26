import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

class Posts extends StatelessWidget {
  final List<Map<String, String>> posts = [
    {
      "title": "Time \nManagement",
      "date": "13/02/2024",
      "image": "lib/images/avatar1.jpeg",
    },
    {
      "title": "Planning \nEffectively",
      "date": "13/01/2024",
      "image": "lib/images/avatar2.jpg",
    },{
      "title": "Planning \nEffectively",
      "date": "13/01/2024",
      "image": "lib/images/avatar2.jpg",
    },{
      "title": "Planning \nEffectively",
      "date": "13/01/2024",
      "image": "lib/images/avatar2.jpg",
    },{
      "title": "Planning \nEffectively",
      "date": "13/01/2024",
      "image": "lib/images/avatar2.jpg",
    },{
      "title": "Planning \nEffectively",
      "date": "13/01/2024",
      "image": "lib/images/avatar2.jpg",
    },
    // Add more posts here...
  ];

  @override
  Widget build(BuildContext context) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Container(
                padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 15),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15)
                  ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(post["title"]!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                            SizedBox(height: 20,),

                            Text(post["date"]!, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              child: RandomAvatar("saytoonz",width: 150, height: 150),
                            ),
                          ],
                        ),
                      ],
                    ),
                );
            },
          );
  }
}
