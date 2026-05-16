import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/location_provider.dart';
import '../providers/auth_provider.dart';
import '../services/payment_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  _showClearCartDialog(context, cart);
                },
                tooltip: 'Clear Cart',
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'signout') {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                await auth.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/signin',
                    (route) => false,
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'signout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                ),
              ),
            ],
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              // Cart items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];
                    return _buildCartItemCard(context, cartItem, cart);
                  },
                ),
              ),

              // Cart summary
              _buildCartSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some products to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    CartItem cartItem,
    CartProvider cart,
  ) {
    final product = cartItem.product;
    final itemTotal = product.effectivePrice * cartItem.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                                          'UGX ${product.effectivePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (product.hasDiscount)
                    Text(
                      'UGX ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),

            // Quantity controls
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: cartItem.quantity > 1
                            ? () {
                                cart.updateQuantity(
                                  product.id,
                                  cartItem.quantity - 1,
                                );
                              }
                            : null,
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          cartItem.quantity.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () {
                          cart.updateQuantity(
                            product.id,
                            cartItem.quantity + 1,
                          );
                        },
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'UGX ${itemTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Remove button
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
              onPressed: () {
                cart.removeItem(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} removed from cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartProvider cart) {
    final shipping = cart.totalAmount > 365000 ? 0.0 : 36500.0;
    final tax = cart.totalAmount * 0.08;
    final total = cart.totalAmount + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text('UGX ${cart.totalAmount.toStringAsFixed(2)}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shipping'),
              Text(
                shipping == 0 ? 'FREE' : 'UGX ${shipping.toStringAsFixed(2)}',
                style: TextStyle(
                  color: shipping == 0 ? Colors.green : null,
                  fontWeight: shipping == 0 ? FontWeight.w500 : null,
                ),
              ),
            ],
          ),
          if (shipping > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'UGX ${(100000 - cart.totalAmount).toStringAsFixed(2)} more for FREE shipping',
                    style: const TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tax (8%)'),
              Text('UGX ${tax.toStringAsFixed(2)}'),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'UGX ${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                _showCheckoutDialog(context, cart, total);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(
    BuildContext context,
    CartProvider cart,
    double total,
  ) {
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    MobileMoneyProvider selectedProvider = MobileMoneyProvider.mtnMoMo;
    bool isProcessing = false;

    // Pre-fill address if current location available
    if (locationProvider.currentAddress != null) {
      addressController.text = locationProvider.currentAddress!.fullAddress;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Checkout'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total: UGX ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location section
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      const Text('Delivery Location'),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          await locationProvider.getCurrentLocation();
                          if (locationProvider.currentAddress != null) {
                            addressController.text =
                                locationProvider.currentAddress!.fullAddress;
                            setDialogState(() {});
                          }
                        },
                        child: const Text('Use Current'),
                      ),
                    ],
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Shipping Address',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your delivery address',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),

                  // Phone number
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      hintText: 'Enter mobile money number',
                      prefixText: '+233 ',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),

                  // Mobile money provider selection
                  DropdownButtonFormField<MobileMoneyProvider>(
                    initialValue: selectedProvider,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Money Provider',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: MobileMoneyProvider.mtnMoMo,
                        child: Text('MTN Mobile Money'),
                      ),
                      DropdownMenuItem(
                        value: MobileMoneyProvider.vodafoneCash,
                        child: Text('Vodafone Cash'),
                      ),
                      DropdownMenuItem(
                        value: MobileMoneyProvider.airtelMoney,
                        child: Text('Airtel Money'),
                      ),
                      DropdownMenuItem(
                        value: MobileMoneyProvider.orangeMoney,
                        child: Text('Orange Money'),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedProvider = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You will receive a prompt to complete payment on your phone.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (isProcessing) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isProcessing
                    ? null
                    : () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isProcessing
                    ? null
                    : () async {
                        if (addressController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter shipping address'),
                            ),
                          );
                          return;
                        }
                        if (phoneController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter phone number'),
                            ),
                          );
                          return;
                        }

                        setDialogState(() => isProcessing = true);

                        try {
                          final paymentService = PaymentServiceFactory.create();
                          final paymentResult = await paymentService
                              .processPayment(
                                amount: total,
                                currency: 'GHS',
                                phoneNumber: phoneController.text.trim(),
                                provider: selectedProvider,
                                orderId:
                                    'ORD-${DateTime.now().millisecondsSinceEpoch}',
                              );

                          setDialogState(() => isProcessing = false);

                          if (!context.mounted) return;

                          if (paymentResult.success) {
                            Navigator.pop(dialogContext); // Close dialog

                            final ordersProvider = Provider.of<OrdersProvider>(
                              context,
                              listen: false,
                            );
                            ordersProvider.addOrder(
                              cart.items,
                              total,
                              addressController.text,
                            );

                            cart.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order placed successfully!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            Future.delayed(const Duration(seconds: 2), () {
                              if (!context.mounted) return;
                              Navigator.pushReplacementNamed(
                                context,
                                '/orders',
                              );
                            });
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  paymentResult.errorMessage ??
                                      'Payment failed. Please try again.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          setDialogState(() => isProcessing = false);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: const Text('Pay & Place Order'),
              ),
            ],
          );
        },
      ),
    );
  }
}
