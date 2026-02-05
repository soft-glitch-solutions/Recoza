import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  // Dummy data for households
  final List<Map<String, dynamic>> households = const [
    {
      'name': 'Mama Zulu',
      'address': '123 Main St',
      'items': '2 bags bottles, 1 bag plastic',
      'status': 'ready',
      'estimatedWeight': '12.5 kg',
      'earnings': 'R 95',
    },
    {
      'name': 'Thabo\'s Family',
      'address': '45 Oak Ave',
      'items': '1 bag cans, 3 bags plastic',
      'status': 'ready',
      'estimatedWeight': '18.2 kg',
      'earnings': 'R 140',
    },
    {
      'name': 'Sister Nomsa',
      'address': '78 Pine Rd',
      'items': '1 bag bottles',
      'status': 'pending',
      'estimatedWeight': '5.0 kg',
      'earnings': 'R 38',
    },
    {
      'name': 'Uncle Sipho',
      'address': '90 Birch St',
      'items': '2 bags mixed',
      'status': 'ready',
      'estimatedWeight': '15.0 kg',
      'earnings': 'R 115',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Set collection day
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share invite link
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Weekly Summary Card
          _buildWeeklySummary(),
          
          // Collection Day Banner
          _buildCollectionDayBanner(),
          
          // Households List
          Expanded(
            child: _buildHouseholdsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Confirm collection
          _showCollectionConfirmation(context);
        },
        icon: const Icon(Icons.check_circle),
        label: const Text('Confirm Collection'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This Week\'s Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('Friday'),
                  backgroundColor: Colors.blue,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Households', '12', Icons.group),
                _buildSummaryItem('Est. Weight', '78 kg', Icons.scale),
                _buildSummaryItem('Est. Earnings', 'R 620', Icons.monetization_on),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue[700]),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionDayBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.green[50],
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.green[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Collection day: Friday, 9 AM - 5 PM',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Change collection day
            },
            child: Text(
              'CHANGE',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: households.length,
      itemBuilder: (context, index) {
        final household = households[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: household['status'] == 'ready' 
                  ? Colors.green[100] 
                  : Colors.orange[100],
              child: Icon(
                Icons.person,
                color: household['status'] == 'ready' 
                    ? Colors.green[700] 
                    : Colors.orange[700],
              ),
            ),
            title: Text(
              household['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(household['address']),
                Text(
                  household['items'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      '${household['estimatedWeight']}',
                      Icons.scale,
                      Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      household['earnings'],
                      Icons.monetization_on,
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
            trailing: Checkbox(
              value: household['status'] == 'ready',
              onChanged: (bool? value) {
                // Toggle collection status
              },
              fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.green[700]!;
                  }
                  return Colors.grey[300]!;
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Chip(
      label: Text(text),
      avatar: Icon(icon, size: 16, color: color),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }

  void _showCollectionConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Collection'),
          content: const Text(
            'Are you ready to collect from all selected households? '
            'This will notify them that you\'re coming today.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Save collection plan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Collection plan confirmed!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
              child: const Text('Confirm Collection'),
            ),
          ],
        );
      },
    );
  }
}