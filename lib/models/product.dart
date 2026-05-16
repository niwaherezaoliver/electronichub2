class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double? discountPrice;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.discountPrice,
    this.rating = 4.5,
    this.reviewCount = 100,
  });

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  double get effectivePrice => discountPrice ?? price;
}

final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'iPhone 15 Pro',
    description:
        'Latest iPhone with A17 Pro chip, titanium design, and 48MP camera system',
    price: 999.00,
    discountPrice: 949.00,
    imageUrl: 'https://i.ebayimg.com/images/g/wSIAAeSwe5lp3AUn/s-l1600.webp',
    category: 'Phones',
    rating: 4.9,
    reviewCount: 1250,
  ),
  Product(
    id: '2',
    name: 'Samsung Galaxy S24 Ultra',
    description:
        ' a flagship 2024 Android smartphone featuring a durable titanium frame, a 6.8-inch flat QHD+ display with a 2,600-nit peak brightness, and an integrated S Pen. Powered by the Snapdragon 8 Gen 3 chipset, it boasts AI-driven features, a 200MP quad-camera system, and a 5,000mAh battery.',
    price: 1199.00,
    imageUrl: 'https://cdn.mos.cms.futurecdn.net/7hF8iPxKy3mJLogwdQuMMH.png',
    category: 'Phones',
    rating: 4.8,
    reviewCount: 890,
  ),
  Product(
    id: '3',
    name: 'MacBook Pro 16"',
    description:
        'The 16-inch model is designed for professionals needing maximum screen space, power, and battery life, making it a heavier, more capable alternative to the 14-inch version.',
    price: 2499.00,
    imageUrl:
        'https://www.shutterstock.com/image-photo/november-20-2024-kyiv-ukraine-260nw-2552520959.jpg',
    category: 'Laptops',
    rating: 4.9,
    reviewCount: 650,
  ),
  Product(
    id: '4',
    name: 'Dell XPS 15',
    description:
        'Dell XPS laptops are premium, high-performance, and stylishly designed devices, often considered top Windows alternatives to the MacBook Pro, featuring slim, machined aluminum chassis and thin-bezel InfinityEdge displays. Latest models (2026) are powered by Intel Core Ultra processors (AI PC capabilities), offering 13.4" to 16.3" screen options, high-end display technologies like OLED, and excellent portability.',
    price: 1799.00,
    discountPrice: 1599.00,
    imageUrl:
        'https://s.yimg.com/ny/api/res/1.2/f0MRjNtCf5EDq8hUtr0Jaw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg-/https://media.zenfs.com/en/digital_trends_ecomm_415/a4c436afe71d5b299bb041a5225dd880',
    category: 'Laptops',
    rating: 4.7,
    reviewCount: 420,
  ),
  Product(
    id: '5',
    name: 'Sony WH-1000XM5',
    description:
        'Industry-leading noise canceling wireless headphones with exceptional sound',
    price: 349.00,
    discountPrice: 299.00,
    imageUrl: 'https://i.ebayimg.com/images/g/8VMAAeSwdEdpFCef/s-l1600.webp',
    category: 'Audio',
    rating: 4.8,
    reviewCount: 2100,
  ),
  Product(
    id: '6',
    name: 'Apple Watch Ultra 2',
    description:
        'Rugged smartwatch for outdoor adventures with precision GPS and 36-hour battery',
    price: 799.00,
    imageUrl:
        'https://www.shutterstock.com/image-photo/bangkok-thailand-sep-23-2024-600nw-2526534089.jpg',
    category: 'Wearables',
    rating: 4.7,
    reviewCount: 380,
  ),
  Product(
    id: '7',
    name: 'iPad Pro 12.9"',
    description:
        'The ultimate iPad experience with M2 chip and stunning Liquid Retina XDR display',
    price: 1099.00,
    imageUrl: 'https://cdn.mos.cms.futurecdn.net/aPXcH72JdQB2KdzNVdZt7m.jpg',
    category: 'Tablets',
    rating: 4.8,
    reviewCount: 720,
  ),
  Product(
    id: '8',
    name: 'Samsung 65" OLED TV',
    description: 'Stunning 4K OLED TV with量子点 technology and Dolby Atmos',
    price: 1999.00,
    discountPrice: 1799.00,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3rbaZWhJTCWrWvBnpnc5ZG00OItKeQ0h3zA&s',
    category: 'TVs',
    rating: 4.6,
    reviewCount: 290,
  ),
  Product(
    id: '9',
    name: 'GoPro Hero 12',
    description:
        'Ultra-versatile action camera with 5.3K video and HyperSmooth stabilization',
    price: 399.00,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9HJKwRcQEGjslxKfmhcCHyjG35DbbLznJEg&s',
    category: 'Cameras',
    rating: 4.5,
    reviewCount: 560,
  ),
  Product(
    id: '10',
    name: 'Bose QuietComfort Ultra',
    description:
        'Premium noise-cancelling earbuds with immersive audio and comfortable fit',
    price: 299.00,
    imageUrl:
        'https://i.rtings.com/assets/products/og42voeg/bose-quietcomfort-ultra-headphones-wireless/design-medium.jpg?format=auto',
    category: 'Audio',
    rating: 4.6,
    reviewCount: 890,
  ),
  Product(
    id: '11',
    name: 'NVIDIA RTX 4090',
    description:
        'Ultimate GeForce GPU for gaming and AI workloads with 24GB GDDR6X',
    price: 1599.00,
    imageUrl: 'https://cdn.mos.cms.futurecdn.net/XE723Ygc6FrqX3CktD6LJ8.jpg',
    category: 'Components',
    rating: 4.9,
    reviewCount: 340,
  ),
  Product(
    id: '12',
    name: 'DJI Mini 4 Pro',
    description:
        'Compact drone with 4K/60fps HDR video and omnidirectional obstacle sensing',
    price: 759.00,
    discountPrice: 699.00,
    imageUrl:
        'https://amateurphotographer.com/wp-content/uploads/sites/7/2023/09/Obstacle-avoidance-function.jpg?w=900',
    category: 'Drones',
    rating: 4.7,
    reviewCount: 180,
  ),
  Product(
    id: '13',
    name: 'PlayStation 5',
    description:
        'Next-gen gaming console with ultra-high speed SSD and ray tracing',
    price: 499.00,
    imageUrl: 'https://i.ebayimg.com/images/g/9qgAAeSwrHRp4~2F/s-l1600.webp',
    category: 'Gaming',
    rating: 4.9,
    reviewCount: 3200,
  ),
  Product(
    id: '14',
    name: 'LG 27" OLED Gaming Monitor',
    description:
        'Ultra-fast 240Hz gaming monitor with 0.1ms response time and G-Sync',
    price: 899.00,
    imageUrl:
        'https://m.media-amazon.com/images/I/61cDzftjbRL.jpg_BO30,255,255,255_UF750,750_SR1910,1000,0,C_QL100_.jpg',
    category: 'Monitors',
    rating: 4.6,
    reviewCount: 210,
  ),
  Product(
    id: '15',
    name: 'Power adapters',
    description:
        'Modern adapters are becoming more versatile, with many USB-C chargers ',
    price: 249.00,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW-KRPtw1QAu5bsZRjk3XMUZHFUX-Q_SCw1w&s',
    category: 'E-Readers',
    rating: 4.5,
    reviewCount: 450,
  ),
  Product(
    id: '16',
    name: 'Raspberry Pi 5',
    description:
        'The Raspberry Pi 5 is a high-performance single-board computer (SBC) featuring a 2.4GHz quad-core Arm Cortex-A76 processor, delivering 2–3× faster performance than its predecessor. Released in late 2023, it introduces in-house silicon (RP1 I/O controller), up to 16GB RAM, dual 4Kp60 display output, and a PCIe 2.0 interface for fast peripherals.',
    price: 79.00,
    imageUrl: 'https://cdn-shop.adafruit.com/970x728/5813-01.jpg',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),
  Product(
    id: '16',
    name: 'Hard disks',
    description:
        'While SSDs (Solid State Drives) are faster and more robust, HDDs are generally more economical for storing massive amounts of data. HDDs have a typical lifespan of 3 to 5 years, as moving parts can wear out.',
    price: 79.00,
    imageUrl:
        'https://t3.ftcdn.net/jpg/04/05/10/18/360_F_405101877_maOJa2aFqB76u9zgqgmgQH05hWYWntYQ.jpg',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),

  Product(
    id: '16',
    name: 'Home theatre',
    description:
        'A well-designed home theatre, enhanced by proper room acoustics, transports the viewer by providing,better sound and visual immersion than standard TV speakers.',
    price: 79.00,
    imageUrl:
        'https://www.shutterstock.com/image-illustration/home-cinemar-system-tv-oudspeakers-260nw-243207712.jpg',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),
  Product(
    id: '16',
    name: 'Cameras',
    description:
        'A camera is an instrument used to capture and store images and videos, either digitally via an electronic image sensor, or chemically via a light-sensitive',
    price: 79.00,
    imageUrl:
        'https://keldco.com/cdn/shop/articles/Gemini_Generated_Image_1itvpn1itvpn1itv.png?v=1758061916&width=2048',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),

  Product(
    id: '16',
    name: 'Monitors',
    description:
        'A computer monitor is an output device that displays information in pictorial or textual form. A discrete monitor comprises a visual display, support electronics, power supply, housing, electrical connectors, and external user controls.',
    price: 79.00,
    imageUrl:
        'https://www.hp.com/content/dam/digitnav/menu/aug_2025/desktops-for-home%402x.jpg',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),

  Product(
    id: '16',
    name: 'Cables',
    description:
        'Electrical cables are assemblies of one or more insulated conductors—typically copper or aluminum—housed within a protective outer sheath, designed to transmit electrical power or communication signals. They provide safe, efficient energy transfer and data communication in residential, industrial, and telecommunication infrastructures.',
    price: 79.00,
    imageUrl:
        'https://thumbs.dreamstime.com/b/different-electric-white-cables-wire-wound-skeins-rings-wires-cable-products-samples-store-142703619.jpg',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),

  Product(
    id: '16',
    name: 'Electric pressure cooker',
    description:
        'Time and Energy Efficiency: Drastically reduces cooking time for slow-simmered dishes (stews, beans, tough cuts of meat) and saves significantly on energy costs compared to traditional cooking.',
    price: 79.00,
    imageUrl:
        'https://image.made-in-china.com/202f0j00cyYbpgQaVkqR/13-in-1-Smart-WiFi-Electric-Pressure-Cooker-APP-Control.webp',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),

  Product(
    id: '16',
    name: 'Rice cooker',
    description:
        'It simplifies cooking by automatically switching from "cook" to "keep warm" when moisture evaporates, typically featuring a non-stick pot and sometimes a steaming tray for vegetables.',
    price: 79.00,
    imageUrl:
        'https://walfosbrand.com/cdn/shop/articles/Best_Commercial_Rice_Cookers_Reviews_4bb5f23d-06bd-446d-b944-23a8f5730d95.jpg?v=1739560766',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),
  Product(
    id: '16',
    name: 'Home appliances',
    description:
        'electrical or mechanical machines designed to assist with routine household functions, such as cooking, cleaning, food preservation, and thermal comfort. They are categorized into major "white goods" (refrigerators, washers) and small appliances (toasters, blenders). These devices aim to improve convenience, save time, and enhance efficiency in residential, institutional, or commercial settings.',
    price: 79.00,
    imageUrl:
        'https://t3.ftcdn.net/jpg/03/29/32/18/360_F_329321873_tWphXnKQHwtZzj4xHUvFRsnaL6cEoLtX.jpg',
    category: 'Components',
    rating: 4.7,
    reviewCount: 680,
  ),
];

List<String> categories = [
  'All',
  'Phones',
  'Laptops',
  'Tablets',
  'Audio',
  'Wearables',
  'TVs',
  'Cameras',
  'Gaming',
  'Components',
  'Drones',
  'E-Readers',
  'Monitors',
];
