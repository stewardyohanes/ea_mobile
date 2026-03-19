class User {
  final String id;
  final String? name;
  final String email;
  final String plan;
  final String? planExpiry;
  final String? referralCode;
  final int? winRate;
  final int? totalSignals;

  const User({
    required this.id,
    this.name,
    required this.email,
    required this.plan,
    this.planExpiry,
    this.referralCode,
    this.winRate,
    this.totalSignals,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String,
      plan: json['plan'] as String,
      planExpiry: json['plan_expiry'] as String?,
      referralCode: json['referral_code'] as String?,
      winRate: json['win_rate'] as int?,
      totalSignals: json['total_signals'] as int?,
    );
  }

  User copyWith({
    String? plan,
    String? planExpiry,
    int? winRate,
    int? totalSignals,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      plan: plan ?? this.plan,
      planExpiry: planExpiry ?? this.planExpiry,
      referralCode: referralCode,
      winRate: winRate ?? this.winRate,
      totalSignals: totalSignals ?? this.totalSignals,
    );
  }

  bool get isPremium =>
      plan.toLowerCase() == 'premium' || plan.toLowerCase() == 'affiliate';
  bool get isAffiliate => plan.toLowerCase() == 'affiliate';
}
