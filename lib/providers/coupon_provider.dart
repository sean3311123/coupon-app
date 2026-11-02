import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coupon.dart';
import '../services/api_service.dart';

class CouponProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Coupon> _coupons = [];
  List<Coupon> _filteredCoupons = [];
  bool _isLoading = false;
  String _currentTab = '推荐';
  String _selectedPlatform = '全部';

  List<Coupon> get coupons => _filteredCoupons;
  bool get isLoading => _isLoading;
  String get currentTab => _currentTab;
  String get selectedPlatform => _selectedPlatform;

  CouponProvider() {
    loadCoupons();
    _loadCollectedStatus();
  }

  Future<void> loadCoupons() async {
    _isLoading = true;
    notifyListeners();
    _coupons = await _apiService.fetchCoupons();
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void switchTab(String tab) {
    _currentTab = tab;
    _applyFilters();
    notifyListeners();
  }

  void filterByPlatform(String platform) {
    _selectedPlatform = platform;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Coupon> result = List.from(_coupons);
    if (_selectedPlatform != '全部') {
      result = result.where((c) => c.platform == _selectedPlatform).toList();
    }
    switch (_currentTab) {
      case '热榜':
        result.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case '即将过期':
        result.sort((a, b) => a.expireAt.compareTo(b.expireAt));
        result = result.where((c) => c.expireAt.difference(DateTime.now()).inDays <= 3).toList();
        break;
      case '免单0元券':
        result = result.where((c) => c.amount >= c.originalPrice * 0.8).toList();
        break;
      default:
        result.sort((a, b) => b.amount.compareTo(a.amount));
    }
    _filteredCoupons = result;
  }

  Future<void> toggleCollect(Coupon coupon) async {
    coupon.isCollected = !coupon.isCollected;
    final prefs = await SharedPreferences.getInstance();
    final collectedIds = prefs.getStringList('collected_coupon_ids') ?? [];
    coupon.isCollected ? collectedIds.add(coupon.id) : collectedIds.remove(coupon.id);
    await prefs.setStringList('collected_coupon_ids', collectedIds);
    notifyListeners();
  }

  Future<void> _loadCollectedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final collectedIds = prefs.getStringList('collected_coupon_ids') ?? [];
    for (var coupon in _coupons) {
      if (collectedIds.contains(coupon.id)) coupon.isCollected = true;
    }
  }
}
