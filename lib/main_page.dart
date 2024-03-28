import 'package:flutter/material.dart';
import 'package:postgres_crud/Models/model.dart';
import 'package:postgres_crud/api_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ApiHandler api = ApiHandler();
  late List<Patient> data = [];
  late bool _isAddingPatient = false;

  // Controllers to handle user input
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<Patient> newData = await api.getPatients();
    setState(() {
      data = newData;
    });
  }

  void toggleAddForm() {
    setState(() {
      _isAddingPatient = !_isAddingPatient;
    });
  }

  // Add new patient
  void addPatient() async {
    try {
      // print('ID: ${idController.text}');
      // print('Name: ${nameController.text}');
      // print('Address: ${addressController.text}');
      // print('City: ${cityController.text}');
      // print('Age: ${ageController.text}');
      // print('Gender: ${genderController.text}');
      // Create a new patient object using the values from text controllers
      Patient newPatient = Patient(
        id: idController.text.trim(),
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        age: int.parse(ageController.text.trim()),
        gender: genderController.text.trim(),
      );

      // Add data to API
      await api.addPatient(newPatient);

      // Refresh data
      getData();

      // Clear text controllers
      idController.clear();
      nameController.clear();
      addressController.clear();
      cityController.clear();
      ageController.clear();
      genderController.clear();

      // Hide the add form
      toggleAddForm();
    } catch (e) {
      print("Error adding patient: $e");
    }
  }

  // Delete patient
  void deletePatient(String id) async {
    try {
      await api.deletePatient(id);
      getData();
    } catch (e) {
      print("Error deleting patient: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postgres CRUD'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _isAddingPatient
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(labelText: 'ID'),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: 'City'),
                  ),
                  TextField(
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                  ),
                  TextField(
                    controller: genderController,
                    decoration: InputDecoration(labelText: 'Gender'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addPatient,
                    child: Text('Save'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Name: ${data[index].name}'),
                  subtitle: Text('Age: ${data[index].age} - Male: ${data[index].gender} \nAddress: ${data[index].address} - City: ${data[index].city}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deletePatient(data[index].id);
                    },
                  ),
                  onTap: () {
                    // Navigate to patient detail page or implement edit functionality
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toggleAddForm();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // void deletePatient(String id) async {
  //   try {
  //     await api.deletePatient(id);
  //     getData(); // Refresh the patient list after deletion
  //   } catch (e) {
  //     print("Error deleting patient: $e");
  //     // Handle error if needed
  //   }
  // }
}
