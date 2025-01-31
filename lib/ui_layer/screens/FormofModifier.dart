import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../provider/modifierprovider.dart';

class ModifierFormScreen extends StatefulWidget {
  @override
  _ModifierFormScreenState createState() => _ModifierFormScreenState();
}

class _ModifierFormScreenState extends State<ModifierFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields controllers
  final TextEditingController _pluController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modifierGroupDescriptionController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  bool _isActive = true;

  // Create an instance of ModifierGroupProvider
  final ModifierGroupProvider _provider = ModifierGroupProvider();

  // Handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final modifierData = {
        "PLU": _pluController.text,
        "name": _nameController.text,
        "modifier_group_description": _modifierGroupDescriptionController.text,
        "min": int.tryParse(_minController.text) ?? 0,
        "max": int.tryParse(_maxController.text) ?? 0,
        "active": _isActive,
        "vendorId": 1,
      };

      String result = await _provider.createModifierGroup(modifierData);

      // Show toast and pop back if successful
      if (result == "201: Created") {
        Fluttertoast.showToast(
          msg: "Modifier created successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        await _provider.fetchModifierGroups(1, 1, 10);
        Navigator.pop(context, true); // Pop back and signal list refresh
      } else {
        Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modifier Form",
          style: TextStyle(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02), // Add padding at the top
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_nameController, 'Name', 'Please enter a name'),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  _modifierGroupDescriptionController,
                  'Modifier Group Description',
                  'Please enter a description',
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(_pluController, 'PLU', 'Please enter a PLU'),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(_minController, 'Min', 'Please enter a minimum value',
                    isNumber: true),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(_maxController, 'Max', 'Please enter a maximum value',
                    isNumber: true),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isActive = newValue ?? true;
                        });
                      },
                    ),
                    Text(
                      "Active",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.3,
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String label, String errorText,
      {bool isNumber = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02), // Adjust padding between fields
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.015,
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorText;
          }
          return null;
        },
      ),
    );
  }
}
