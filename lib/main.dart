import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/firebase_service.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/location_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/location_provider.dart';
import 'providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'ElectronicHub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/signin',
        routes: {
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/products': (context) => const ProductsScreen(),
          '/product_detail': (context) => ProductDetailScreen(
            product: ModalRoute.of(context)!.settings.arguments as dynamic,
          ),
          '/cart': (context) => const CartScreen(),
          '/orders': (context) => const OrdersScreen(),
          '/admin': (context) => const AdminScreen(),
          '/location': (context) => const LocationScreen(),
        },
      ),
    );
  }
}
