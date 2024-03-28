import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/todos': (context) => TodoList(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/profile': (context) => ProfilePage(
              name: '',
              todos: [],
            ),
      },
    );
  }
}

class SignupPage extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();

  Future<void> _signUp(BuildContext context) async {
    final url =
        'http://localhost:3000/signup'; // Replace with your backend server URL
    print('Username: ${usernameController.text}');
    print('Password: ${passwordController.text}');
    print('Username: ${usernameController.text}');
    print('Password: ${passwordController.text}');

    final body = json.encode({
      'username': usernameController.text,
      'password': passwordController.text,
    });
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Specify the content type as JSON
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Signup successful
      // Navigate to the desired page (e.g., TodoList)
      Navigator.pushNamed(context, '/login');
    } else {
      // Signup failed
      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Failed'),
          content:
              Text('An error occurred while signing up. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Signup',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: retypePasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Retype Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _signUp(context);
                    },
                    child: Text('Signup'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final url =
        'http://localhost:3000/login'; // Replace with your backend server URL
    final Map<String, String> data = {
      'username': usernameController.text,
      'password': passwordController.text,
    };
    final String jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      // Login successful
      // Navigate to the TodoList page
      Navigator.pushNamed(context, '/todos',
          arguments: usernameController.text);
    } else {
      // Login failed
      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid username or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _login(context);
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todos = [];
  late String username;

  TextEditingController controller = TextEditingController();
  int selectedPriority = 3; // Default priority is Low

  @override
  Widget build(BuildContext context) {
    username = ModalRoute.of(context)!.settings.arguments as String;

    // Print the username to the console
    print('Logged in as: $username');
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Todo List',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    name: username, // Example name
                    todos: todos,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(10.0),
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: todos.isEmpty
                ? Center(
                    child: Text(
                      'No todos yet!',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        color: _getPriorityColor(todos[index].priority)
                            .withOpacity(0.9),
                        child: ListTile(
                          title: Text(
                            todos[index].title,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editTodoDialog(context, index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    todos.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red; // High priority
      case 2:
        return Colors.orange; // Medium priority
      case 3:
        return Colors.green; // Low priority
      default:
        return Colors.grey; // Default priority
    }
  }

  void _addTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter your todo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectedPriority,
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('High'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('Medium'),
                  ),
                  DropdownMenuItem<int>(
                    value: 3,
                    child: Text('Low'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ADD'),
              onPressed: () {
                setState(() {
                  final todoText = controller.text;
                  final todoPriority = selectedPriority;
                  if (todoText.isNotEmpty) {
                    todos
                        .add(TodoItem(title: todoText, priority: todoPriority));
                    controller.clear();
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editTodoDialog(BuildContext context, int index) {
    TextEditingController editController = TextEditingController();
    editController.text = todos[index].title;
    int selectedEditPriority = todos[index].priority;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                decoration: InputDecoration(
                  hintText: 'Enter your todo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectedEditPriority,
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('High'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('Medium'),
                  ),
                  DropdownMenuItem<int>(
                    value: 3,
                    child: Text('Low'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedEditPriority = value!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('SAVE'),
              onPressed: () {
                setState(() {
                  final editedText = editController.text;
                  final editedPriority = selectedEditPriority;
                  if (editedText.isNotEmpty) {
                    todos[index] =
                        TodoItem(title: editedText, priority: editedPriority);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TodoItem {
  final String title;
  final int priority;

  TodoItem({required this.title, required this.priority});
}

class ProfilePage extends StatelessWidget {
  final String name;
  final List<TodoItem> todos;

  ProfilePage({
    required this.name,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the number of tasks for each priority
    int highPriorityTasks = todos.where((task) => task.priority == 1).length;
    int mediumPriorityTasks = todos.where((task) => task.priority == 2).length;
    int lowPriorityTasks = todos.where((task) => task.priority == 3).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                name[0],
                style: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'High Priority Tasks: $highPriorityTasks',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Medium Priority Tasks: $mediumPriorityTasks',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Low Priority Tasks: $lowPriorityTasks',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
