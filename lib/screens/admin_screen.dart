import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    if (!auth.isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Access denied. Admin privileges required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.inventory), label: Text('Products')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Users')),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                _ProductsTab(),
                _UsersTab(),
                _SettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsTab extends StatefulWidget {
  const _ProductsTab();

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String _selectedCategory = 'Phones';
  Product? _editingProduct;

  void _clearControllers() {
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _selectedCategory = 'Phones';
    _editingProduct = null;
  }

  void _showAddEditProductDialog({Product? product}) {
    if (product != null) {
      _editingProduct = product;
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _descriptionController.text = product.description;
      _imageUrlController.text = product.imageUrl;
      _selectedCategory = product.category;
    } else {
      _clearControllers();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingProduct != null ? 'Edit Product' : 'Add New Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Product Name')),
              TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL')),
              DropdownButtonFormField(
                initialValue: _selectedCategory,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => _selectedCategory = v!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () {
            _clearControllers();
            Navigator.pop(context);
          }, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (_editingProduct != null) {
                final index = sampleProducts.indexWhere((p) => p.id == _editingProduct!.id);
                if (index != -1) {
                  sampleProducts[index] = Product(
                    id: _editingProduct!.id,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    price: double.tryParse(_priceController.text) ?? 0,
                    imageUrl: _imageUrlController.text,
                    category: _selectedCategory,
                  );
                }
              } else {
                final newProduct = Product(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  description: _descriptionController.text,
                  price: double.tryParse(_priceController.text) ?? 0,
                  imageUrl: _imageUrlController.text,
                  category: _selectedCategory,
                );
                sampleProducts.add(newProduct);
              }
              _clearControllers();
              Navigator.pop(context);
              setState(() {});
            },
            child: Text(_editingProduct != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(int index) {
    setState(() {
      sampleProducts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Products Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(icon: const Icon(Icons.add), label: const Text('Add Product'), onPressed: () => _showAddEditProductDialog()),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sampleProducts.length,
            itemBuilder: (context, index) {
              final product = sampleProducts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                  title: Text(product.name),
                  subtitle: Text('UGX ${product.price.toStringAsFixed(0)} - ${product.category}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showAddEditProductDialog(product: product)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteProduct(index)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UsersTab extends StatefulWidget {
  const _UsersTab();

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  final List<Map<String, dynamic>> _users = [
    {'id': '1', 'email': 'admin', 'role': 'Admin', 'createdAt': '2024-01-01'},
    {'id': '2', 'email': 'user@example.com', 'role': 'User', 'createdAt': '2024-01-15'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Users Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(child: Text(user['email'][0].toUpperCase())),
                  title: Text(user['email']),
                  subtitle: Text('Role: ${user['role']} • Created: ${user['createdAt']}'),
                  trailing: PopupMenuButton(
                    onSelected: (value) {},
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit Role')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete User')),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings - Coming Soon'));
  }
}