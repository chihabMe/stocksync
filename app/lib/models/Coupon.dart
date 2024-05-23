class Coupon {
  final String id;
  final String code;
  final DateTime createdAt;
  final bool expired;
  final DateTime expiryDate;
  final int? discount;

  Coupon(
      {required this.id,
      required this.code,
      required this.createdAt,
      required this.expired,
      required this.expiryDate,
      this.discount});

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      code: json['code'],
      createdAt: DateTime.parse(json['created_at']),
      expired: json['expired'],
      expiryDate: DateTime.parse(json['expiry_date']),
      discount: json['discount'],
    );
  }
}
