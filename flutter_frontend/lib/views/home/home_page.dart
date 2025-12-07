import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 36), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.notifications, size: 36),
                  const SizedBox(width: 16),   // ← thêm padding trái cho Search
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "Search",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),   // ← thêm padding phải giữa Search và Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage("assets/images/avatar.jpg"),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // WELCOME TEXT
              const Text(
                "Keep Striving Juan!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Today's Task",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const Text(
                "February 10, 2026",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // TASK CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "5:45 AM",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Workout Great Job!",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("VIEW ALL"),
                          )
                        ],
                      ),
                    ),

                    Image.asset(
                      "assets/images/logo.png",
                      width: 110,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // PROGRESS
              const Text(
                "Your progress for today",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              LinearProgressIndicator(
                value: 0.35,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 10,
              ),

              const SizedBox(height: 20),

              // DISCOVER BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Discover new things!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("START"),
                          )
                        ],
                      ),
                    ),
                    Image.asset("assets/images/discover.png", width: 100),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BOOKS SECTION
              const Text(
                "Recommended Books:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildBook("assets/images/book1.png"),
                    buildBook("assets/images/book2.png"),
                    buildBook("assets/images/book3.png"),
                    buildBook("assets/images/book4.png"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // WHY USE APP
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.stacked_line_chart, size: 40),
                    SizedBox(height: 10),
                    Text(
                      "Productive means Progress",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "This app provides tools to organize, prioritize, and manage your discipline.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // QUOTE
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "“Always remember, your focus determines your reality”",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/images/avatar2.jpg"),
                        ),
                        const SizedBox(width: 10),
                        const Text("Tyler Durden"),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildBook(String asset) {
  return Container(
    width: 100,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Image.asset(asset, fit: BoxFit.cover),
  );
}
