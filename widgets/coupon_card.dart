import 'package:flutter/material.dart';
import '../models/coupon.dart';
import '../providers/coupon_provider.dart';
import 'package:provider/provider.dart';

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  const CouponCard({super.key, required this.coupon});

  Color _platformColor() {
    switch (coupon.platform) {
      case '淘宝': return Colors.orange;
      case '京东': return Colors.red[700]!;
      case '拼多多': return Colors.red[400]!;
      case '美团': return Colors.green;
      case '饿了么': return Colors.blue[700]!;
      case '抖音': return Colors.black87;
      case '携程': return Colors.cyan[700]!;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = coupon.expireAt.difference(DateTime.now()).inDays;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            // 左侧金额
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _platformColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('¥', style: TextStyle(fontSize: 14, color: _platformColor(), fontWeight: FontWeight.bold)),
                Text('${coupon.amount.toInt()}', style: TextStyle(fontSize: 22, color: _platformColor(), fontWeight: FontWeight.bold)),
              ]),
            ),
            const SizedBox(width: 12),
            // 中间信息
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: _platformColor(), borderRadius: BorderRadius.circular(4)),
                  child: Text(coupon.platform, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(width: 6),
                if (daysLeft <= 1) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                  child: const Text('即将过期', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ]),
              const SizedBox(height: 6),
              Text(coupon.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              Text(coupon.shopName, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 4),
              Row(children: [
                Text('原价 ¥${coupon.originalPrice.toInt()}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[500], fontSize: 11)),
                const Spacer(),
                Text('剩 $daysLeft 天', style: TextStyle(color: daysLeft <= 1 ? Colors.red : Colors.grey[600], fontSize: 11)),
              ]),
            ])),
            // 右侧收藏
            IconButton(
              icon: Icon(coupon.isCollected ? Icons.favorite : Icons.favorite_border, color: coupon.isCollected ? Colors.red : Colors.grey),
              onPressed: () => Provider.of<CouponProvider>(context, listen: false).toggleCollect(coupon),
            ),
          ]),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (c) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _platformColor(), borderRadius: BorderRadius.circular(6)),
                child: Text(coupon.platform, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Text('¥${coupon.amount.toInt()}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _platformColor())),
              const Text(' 优惠券', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ]),
            const SizedBox(height: 16),
            Text(coupon.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _detailRow('适用店铺', coupon.shopName),
            _detailRow('原价', '¥${coupon.originalPrice.toInt()}'),
            _detailRow('剩余库存', '${coupon.stock} 张'),
            _detailRow('有效期至', '${coupon.expireAt.year}-${coupon.expireAt.month.toString().padLeft(2,'0')}-${coupon.expireAt.day.toString().padLeft(2,'0')}'),
            _detailRow('分类', coupon.category),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(c),
                style: ElevatedButton.styleFrom(backgroundColor: _platformColor(), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('一键领取', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 80, child: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
    ]),
  );
}
