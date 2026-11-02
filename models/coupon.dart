class Coupon {
  final String id;
  final String platform;
  final String title;
  final double amount;
  final double originalPrice;
  final String shopName;
  final DateTime expireAt;
  final int stock;
  final String? imageUrl;
  final String category;
  bool isCollected;

  Coupon({
    required this.id,
    required this.platform,
    required this.title,
    required this.amount,
    required this.originalPrice,
    required this.shopName,
    required this.expireAt,
    required this.stock,
    this.imageUrl,
    this.category = 'other',
    this.isCollected = false,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      platform: json['platform'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      shopName: json['shopName'] as String? ?? '',
      expireAt: DateTime.parse(json['expireAt'] as String),
      stock: json['stock'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String? ?? 'other',
      isCollected: json['isCollected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'platform': platform, 'title': title,
    'amount': amount, 'originalPrice': originalPrice,
    'shopName': shopName, 'expireAt': expireAt.toIso8601String(),
    'stock': stock, 'imageUrl': imageUrl,
    'category': category, 'isCollected': isCollected,
  };
}
