import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coupon_provider.dart';
import '../widgets/coupon_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final tabs = const ['推荐', '热榜', '即将过期', '免单0元券'];
  final platforms = const ['全部', '淘宝', '京东', '拼多多', '美团', '饿了么', '抖音', '携程'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('省钱券集'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: Colors.white,
            child: Consumer<CouponProvider>(
              builder: (c, p, _) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(children: platforms.map((pName) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(pName, style: TextStyle(fontSize: 13)),
                    selected: p.selectedPlatform == pName,
                    onSelected: (_) => p.filterByPlatform(pName),
                    selectedColor: Colors.red[100],
                    labelStyle: TextStyle(
                      color: p.selectedPlatform == pName ? Colors.red : Colors.black87,
                    ),
                  ),
                )).toList()),
              ),
            ),
          ),
        ),
      ),
      body: Column(children: [
        // Tab 栏
        Container(
          color: Colors.white,
          child: Consumer<CouponProvider>(
            builder: (c, p, _) => Row(children: tabs.map((t) => Expanded(
              child: InkWell(
                onTap: () => p.switchTab(t),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: p.currentTab == t ? Colors.red : Colors.transparent,
                      width: 2,
                    )),
                  ),
                  child: Text(t, textAlign: TextAlign.center, style: TextStyle(
                    color: p.currentTab == t ? Colors.red : Colors.grey[600],
                    fontWeight: p.currentTab == t ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  )),
                ),
              ),
            )).toList()),
          ),
        ),
        const SizedBox(height: 2),
        // 列表
        Expanded(child: Consumer<CouponProvider>(
          builder: (c, p, _) {
            if (p.isLoading) return const Center(child: CircularProgressIndicator(color: Colors.red));
            if (p.coupons.isEmpty) return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('暂无优惠券', style: TextStyle(color: Colors.grey[600])),
              ]),
            );
            return RefreshIndicator(
              onRefresh: () => p.loadCoupons(),
              child: ListView.builder(
                itemCount: p.coupons.length,
                itemBuilder: (c, i) => CouponCard(coupon: p.coupons[i]),
              ),
            );
          },
        )),
      ]),
    );
  }
}
