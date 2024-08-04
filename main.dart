import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _loading = true;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        setState(() {
          _users = body.map((dynamic item) => User.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.blueGrey[900], // لون أغمق للبار
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                User user = _users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                      radius: 30,
                    ),
                    title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.email),
                    trailing: Icon(Icons.arrow_forward, color: Colors.blue),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class UserDetailsScreen extends StatelessWidget {
  final User user;

  UserDetailsScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900], // نفس لون البار
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
            ),
            SizedBox(height: 16),
            Text('Email: ${user.email}', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 8),
            Text('Address: ${user.address}', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 8),
            Text('Phone: ${user.phone}', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 8),
            Text('Website: ${user.website}', style: Theme.of(context).textTheme.bodyMedium),
SizedBox(height: 8),
            Text('Company: ${user.company}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String website;
  final String company;
  final String avatarUrl;

  User({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  }) : avatarUrl = 'https://via.placeholder.com/150?text=No+Image';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      address: json['address']['street'] + ', ' + json['address']['city'],
      phone: json['phone'],
      website: json['website'],
      company: json['company']['name'],
    );
  }
}