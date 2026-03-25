class Signal {
  final String id;
  final String symbol;
  final String direction; // 'BUY' | 'SELL'
  final String status; // 'active' | 'tp_hit' | 'sl_hit' | 'closed'
  final double entry1;
  final double? entry2;
  final double sl;
  final double? tp;
  final String trend;
  final double? riskReward;
  final String createdAt;

  const Signal({
    required this.id,
    required this.symbol,
    required this.direction,
    required this.status,
    required this.entry1,
    this.entry2,
    required this.sl,
    this.tp,
    required this.trend,
    this.riskReward,
    required this.createdAt,
  });

  factory Signal.fromJson(Map<String, dynamic> json) {
    return Signal(
      id: json['id'].toString(),
      symbol: json['symbol'] as String,
      direction: json['direction'] as String,
      status: json['status'] as String,
      entry1: (json['entry1'] as num).toDouble(),
      entry2: (json['entry2'] as num?)?.toDouble(),
      sl: (json['sl'] as num).toDouble(),
      tp: (json['tp'] as num?)?.toDouble(),
      trend: json['trend'] as String? ?? '',
      riskReward: (json['risk_reward'] as num?)?.toDouble(),
      createdAt: json['created_at'] as String,
    );
  }

  bool get isBuy => direction == 'BUY';
  bool get isActive => status == 'active';
  bool get isTpHit => status == 'tp_hit';
  bool get isSlHit => status == 'sl_hit';
}
