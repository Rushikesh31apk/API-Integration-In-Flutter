import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast
import '../../data_layer/models/Form_Model.dart'; // Assuming this contains the Results model
import '../../provider/modifierprovider.dart';

class UpdateModifierScreen extends StatefulWidget {
  final Results modifierGroup;

  UpdateModifierScreen({required this.modifierGroup});

  @override
  _UpdateModifierScreenState createState() => _UpdateModifierScreenState();
}

class _UpdateModifierScreenState extends State<UpdateModifierScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  late final TextEditingController _pluController;

  bool _isActive = true;
  final ModifierGroupProvider _provider = ModifierGroupProvider();

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  // Initialize form fields with existing data
  void _initializeFormFields() {
    _nameController = TextEditingController(text: widget.modifierGroup.name);
    _descriptionController = TextEditingController(
        text: widget.modifierGroup.modifierGroupDescription);
    _minController =
        TextEditingController(text: widget.modifierGroup.min.toString());
    _maxController =
        TextEditingController(text: widget.modifierGroup.max.toString());
    _pluController = TextEditingController(text: widget.modifierGroup.plu);
    _isActive = widget.modifierGroup.active;
  }

  // Handle form submission
  Future<void> _updateModifier() async {
    if (_formKey.currentState?.validate() ?? false) {
      final modifierData = {
        "name": _nameController.text,
        "modifier_group_description": _descriptionController.text,
        "min": int.tryParse(_minController.text) ?? 0,
        "max": int.tryParse(_maxController.text) ?? 0,
        "PLU": _pluController.text,
        "active": _isActive,
      };

      try {
        String result = await _provider.updateModifierGroup(
            widget.modifierGroup.id, widget.modifierGroup.vendorId, modifierData);

        // Show success toast
        Fluttertoast.showToast(
          msg: "Update Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.of(context).pop(); // Go back after updating
      } catch (e) {
        // Show error toast
        Fluttertoast.showToast(
          msg: 'Failed to update modifier group',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Modifier",
          style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFormField(
                  controller: _nameController,
                  label: 'Name',
                  validatorMessage: 'Please enter a name',
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                _buildTextFormField(
                  controller: _descriptionController,
                  label: 'Modifier Group Description',
                  validatorMessage: 'Please enter a description',
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                _buildTextFormField(
                  controller: _pluController,
                  label: 'PLU',
                  validatorMessage: 'Please enter a PLU',
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                _buildTextFormField(
                  controller: _minController,
                  label: 'Min',
                  validatorMessage: 'Please enter a minimum value',
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  keyboardType: TextInputType.number,
                ),
                _buildTextFormField(
                  controller: _maxController,
                  label: 'Max',
                  validatorMessage: 'Please enter a maximum value',
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  keyboardType: TextInputType.number,
                ),
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
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateModifier,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.4, vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.04),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}
