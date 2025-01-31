import 'package:flutter/material.dart';
import '../../data_layer/models/Form_Model.dart';
import '../../provider/modifierprovider.dart';
import 'FormofModifier.dart';
import 'UpdateModifierUi.dart';

class ModifierGroupListScreen extends StatefulWidget {
  @override
  _ModifierGroupListScreenState createState() => _ModifierGroupListScreenState();
}

class _ModifierGroupListScreenState extends State<ModifierGroupListScreen> {
  final ModifierGroupProvider _provider = ModifierGroupProvider();
  List<Results> _modifierGroups = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchModifierGroups();
  }

  void _navigateToUpdateModifierScreen(Results modifierGroup) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateModifierScreen(modifierGroup: modifierGroup),
      ),
    );
    _fetchModifierGroups(); // Refresh the list after successful update
  }


  // Show a confirmation dialog before deleting a modifier group
  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this modifier group?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteModifierGroup(id); // Call the delete function
              },
            ),
          ],
        );
      },
    );
  }

  // Handle delete modifier group
  Future<void> _deleteModifierGroup(int id) async {
    try {
      await _provider.deleteModifierGroup(
          id, 1); // Replace vendorId with actual value
      _fetchModifierGroups(); // Refresh the list after deletion
    } catch (e) {
      // Handle any errors silently or log them for debugging
    }
  }

  // Fetch the list of modifier groups
  Future<void> _fetchModifierGroups() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final model = await _provider.fetchModifierGroups(
          1, 1, 10); // Replace with actual page and page_size
      setState(() {
        _modifierGroups = model.results;
      });
    } catch (e) {
      // Handle any errors silently or log them for debugging
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier Groups",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _modifierGroups.isEmpty
          ? Center(child: Text("No modifier groups available."))
          : ListView.builder(
        itemCount: _modifierGroups.length,
        itemBuilder: (context, index) {
          final modifierGroup = _modifierGroups[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Modifier Group Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modifierGroup.name,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text(
                            modifierGroup.modifierGroupDescription,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      // Action Buttons
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _navigateToUpdateModifierScreen(modifierGroup),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _showDeleteConfirmationDialog(modifierGroup.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the form and wait for a result to refresh the list
          final shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModifierFormScreen(),
            ),
          );

          // Refresh the list if the form submission was successful
          if (shouldRefresh == true) {
            _fetchModifierGroups();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
