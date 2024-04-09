import 'package:flutter/material.dart';
import 'package:postgres_crud/Models/model.dart';
import 'package:postgres_crud/api_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Create an instance of the API handler
  ApiHandler api = ApiHandler();
  late List<Patient> data = [];
  late bool _isAddingPatient = false;
  late bool _isEditing = false;

  // Controllers to handle user input
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  // State initialization
  void initState() {
    super.initState();
    getData();
  }
  // Function to get data from API
  void getData() async {
    List<Patient> newData = await api.getPatients();
    setState(() {
      data = newData;
    });
  }

  void toggleAddForm() {
    setState(() {
      _isAddingPatient = !_isAddingPatient;
      _isEditing = false;
    });
  }

  // Function to add patient
  void addPatient() async {
    try {
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

  // Function to delete patient
  void deletePatient(String id) async {
    try {
      await api.deletePatient(id);
      getData();
    } catch (e) {
      print("Error deleting patient: $e");
    }
  }

  // Function show information of patient to edit
  void editPatient(Patient patient) {
    setState(() {
      // Get the patient data and set it to the text controllers
      idController.text = patient.id;
      nameController.text = patient.name;
      addressController.text = patient.address;
      cityController.text = patient.city;
      ageController.text = patient.age.toString();
      genderController.text = patient.gender;

      // Show the add and update form
      _isAddingPatient = true;
      _isEditing = true;
    });
  }

// Function to update patient
  void updatePatient() async {
    try {
      // Create a new patient object using the values from text controllers
      Patient updatedPatient = Patient(
        id: idController.text.trim(),
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        age: int.parse(ageController.text.trim()),
        gender: genderController.text.trim(),
      );

      // Call the updatePatient method from the API handler
      await api.updatePatient(updatedPatient);

      // Get the updated data from the API
      getData();

      // Delete text controllers
      idController.clear();
      nameController.clear();
      addressController.clear();
      cityController.clear();
      ageController.clear();
      genderController.clear();
      _isAddingPatient = false;
      _isEditing = false;
    } catch (e) {
      print("Error updating patient: $e");
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
                    onPressed: _isEditing ? updatePatient : addPatient,
                    child: Text(_isEditing ? 'Update' : 'Save'),
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
                  subtitle: Text(
                      'Age: ${data[index].age} - Male: ${data[index].gender} \nAddress: ${data[index].address} - City: ${data[index].city}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          editPatient(data[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletePatient(data[index].id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {},
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isAddingPatient) {
            toggleAddForm();
          } else {
            // Check if the user is adding or editing a patient record
            _isEditing = false;
            toggleAddForm();
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
