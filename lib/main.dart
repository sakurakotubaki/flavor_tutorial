import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Global variable to identify the current flavor
String currentFlavor = 'unknown';

// Firestore instance
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Main function that takes FirebaseOptions and runs the app
Future<void> mainCommon(FirebaseOptions options, {required String flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set the current flavor
  currentFlavor = flavor;
  
  // Debug info to help diagnose flavor issues
  debugPrint('✨✨✨ FLAVOR SET TO: $currentFlavor ✨✨✨');
  
  // Initialize Firebase with the provided options
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    } else {
      Firebase.app(); // If already initialized, use the default app
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get app name based on which entry point file was used
    String appName = 'Flutter Demo';
    
    // Set different colors for each flavor to make it visually distinctive
    Color seedColor;
    String flavorLabel;
    
    // Use the currentFlavor global variable to determine the UI styling
    switch (currentFlavor) {
      case 'dev':
        seedColor = Colors.blue;
        flavorLabel = '[DEV]';
        break;
      case 'staging':
        seedColor = Colors.amber;
        flavorLabel = '[STAGING]';
        break;
      case 'prod':
        seedColor = Colors.green;
        flavorLabel = '[PROD]';
        break;
      default:
        seedColor = Colors.deepPurple;
        flavorLabel = '';
    }
    
    return MaterialApp(
      title: '$appName $flavorLabel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      ),
      home: MyHomePage(title: '$appName $flavorLabel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  // Reference to the users collection
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the current flavor
            Text(
              'Current Flavor: ${currentFlavor.toUpperCase()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            // Show UI based on the current flavor
            ...switch (currentFlavor) {
              'dev' || 'staging' => [
                Text(
                  'Users from Firestore (${currentFlavor.toUpperCase()}):',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 10),
              // StreamBuilder to display users from Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: usersCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }
                    
                    // Display the list of users
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final name = data['name'] ?? 'No name';
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(name.substring(0, 1).toUpperCase()),
                          ),
                          title: Text(name),
                          subtitle: Text('User ID: ${doc.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
              'prod' => [
                const SizedBox(height: 10),
                const Text(
                  'This is the production environment.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(
                  Icons.verified,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Firestore access is restricted in production.',
                  style: TextStyle(color: Colors.redAccent),
                ),
                Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: usersCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }
                    
                    // Display the list of users
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final name = data['name'] ?? 'No name';
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(name.substring(0, 1).toUpperCase()),
                          ),
                          title: Text(name),
                          subtitle: Text('User ID: ${doc.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
              ],
              _ => [] // Default case for any other flavor
            },
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Show different buttons based on the flavor
          ...switch (currentFlavor) {
            'dev' || 'staging' => [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    // Add a new user to Firestore with a random name
                    try {
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      await usersCollection.add({
                        'name': 'Test User $timestamp ${currentFlavor.toUpperCase()}',
                        'createdAt': FieldValue.serverTimestamp(),
                        'environment': currentFlavor,
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User added successfully')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error adding user: $e')),
                        );
                      }
                    }
                  },
                  heroTag: 'addUser',
                  backgroundColor: currentFlavor == 'dev' ? Colors.green : Colors.orange,
                  child: const Icon(Icons.person_add),
                ),
              ),
            ],
            _ => [] // Empty list for prod and other flavors
          },
          // This button is always shown regardless of flavor
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            heroTag: 'increment',
            child: const Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}