import 'package:flutter/material.dart';

class MyApp11_2 extends StatelessWidget {
  const MyApp11_2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Tech List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> data = [
    {
      "title": "Native App",
      "platform": "Android, iOS",
      "lang": "Java, Kotlin, Swift, C#",
      "color": Colors.red
    },
    {
      "title": "Hybrid App",
      "platform": "Android, iOS, Web",
      "lang": "Javascript, Dart",
      "color": Colors.grey
    }
  ];

  final TextEditingController titleInput = TextEditingController();
  final TextEditingController platInput = TextEditingController();
  final TextEditingController langInput = TextEditingController();

  List<String> colors = ['blue', 'green', 'yellow', 'grey'];

  String? colSelected;

  // ================== FUNCTION COLOR ==================
  Color getColor(String colorName) {
    switch (colorName) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String getColorName(Color color) {
    if (color == Colors.blue) return 'blue';
    if (color == Colors.green) return 'green';
    if (color == Colors.yellow) return 'yellow';
    return 'grey';
  }

  // ================== CREATE & UPDATE ==================
  void showForm({int? index}) {
    if (index != null) {
      // EDIT
      titleInput.text = data[index]['title'];
      platInput.text = data[index]['platform'];
      langInput.text = data[index]['lang'];
      colSelected = getColorName(data[index]['color']);
    } else {
      // ADD
      titleInput.clear();
      platInput.clear();
      langInput.clear();
      colSelected = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Add Tech' : 'Edit Tech'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleInput,
                  decoration: const InputDecoration(
                    labelText: 'Tech Name',
                  ),
                ),
                TextField(
                  controller: platInput,
                  decoration: const InputDecoration(
                    labelText: 'Platform',
                  ),
                ),
                TextField(
                  controller: langInput,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: colSelected,
                  decoration: const InputDecoration(
                    labelText: 'Choose Color',
                  ),
                  items: colors.map((String color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Text(color),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      colSelected = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(index == null ? 'Save' : 'Update'),
              onPressed: () {
                Map<String, dynamic> newData = {
                  'title': titleInput.text,
                  'platform': platInput.text,
                  'lang': langInput.text,
                  'color': getColor(colSelected ?? 'blue'),
                };

                setState(() {
                  if (index == null) {
                    // CREATE
                    data.add(newData);
                  } else {
                    // UPDATE
                    data[index] = newData;
                  }
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ================== DELETE ==================
  void deleteData(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure want to delete this item?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
            onPressed: () {
              setState(() {
                data.removeAt(index);
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF7367F0),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: data[index]['color'],
                child: const Icon(
                  Icons.phone_android,
                  color: Colors.white,
                ),
              ),
              title: Text(
                data[index]['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7367F0),
                ),
              ),
              subtitle: Text(
                "Platform: ${data[index]['platform']}\n"
                "Lang: ${data[index]['lang']}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // UPDATE
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      showForm(index: index);
                    },
                  ),

                  // DELETE
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteData(index);
                    },
                  ),
                ],
              ),

              // READ
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(data[index]['title']),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Platform: ${data[index]['platform']}"),
                          Text("Language: ${data[index]['lang']}"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),

      // CREATE
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7367F0),
        child: const Icon(Icons.add),
        onPressed: () {
          showForm();
        },
      ),
    );
  }
}