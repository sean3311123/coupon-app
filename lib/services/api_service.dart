import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/coupon.dart';

class ApiService {
  // GitHub Actions 打包时用 mock 数据，安装后首次启动也用 mock
  // 部署后端后改成你的服务器地址即可
  static const String baseUrl = 'http://localhost:3000/api';
  static const bool useMock = true; // 打包时默认用 mock，后续可改

  Future<List<Coupon>> fetchCoupons({String? platform, String? category}) async {
    if (useMock) return _getMockCoupons();

    try {
      final queryParams = <String, String>{};
      if (platform != null && platform != '全部') queryParams['platform'] = platform;
      if (category != null) queryParams['category'] = category;

      final uri = Uri.parse('$baseUrl/coupons').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        final List<dynamic> data = result['data'] ?? [];
        return data.map((json) => Coupon.fromJson(json)).toList();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Error: $e');
      return _getMockCoupons(); // 降级
    }
  }

  List<Coupon> _getMockCoupons() => [
    Coupon(id: 'tb_001', platform: '淘宝', title: '秋冬新款羽绒服', amount: 50, originalPrice: 299, shopName: '优衣库官方', expireAt: DateTime.now().add(const Duration(days: 3)), stock: 120, category: 'fashion'),
    Coupon(id: 'jd_002', platform: '京东', title: 'iPhone 15 手机壳', amount: 20, originalPrice: 99, shopName: '数码配件专营', expireAt: DateTime.now().add(const Duration(days: 1)), stock: 500, category: 'digital'),
    Coupon(id: 'pdd_003', platform: '拼多多', title: '抽纸整箱24包', amount: 15, originalPrice: 39.9, shopName: '生活日用', expireAt: DateTime.now().add(const Duration(hours: 5)), stock: 2000, category: 'daily'),
    Coupon(id: 'mt_004', platform: '美团', title: '麻辣烫满减券', amount: 10, originalPrice: 30, shopName: '杨国福麻辣烫', expireAt: DateTime.now().add(const Duration(days: 7)), stock: 50, category: 'food'),
    Coupon(id: 'elm_005', platform: '饿了么', title: '下午茶特惠', amount: 8, originalPrice: 25, shopName: '星巴克', expireAt: DateTime.now().add(const Duration(days: 2)), stock: 30, category: 'food'),
    Coupon(id: 'dy_006', platform: '抖音', title: '网红零食大礼包', amount: 30, originalPrice: 89, shopName: '抖音小店', expireAt: DateTime.now().add(const Duration(days: 5)), stock: 200, category: 'food'),
    Coupon(id: 'ctrip_007', platform: '携程', title: '酒店立减券', amount: 100, originalPrice: 500, shopName: '如家酒店', expireAt: DateTime.now().add(const Duration(days: 10)), stock: 80, category: 'travel'),
    Coupon(id: 'ele_008', platform: '饿了么', title: '新用户免配送费', amount: 6, originalPrice: 6, shopName: '麦当劳', expireAt: DateTime.now().add(const Duration(days: 1)), stock: 999, category: 'food'),
  ];
}
