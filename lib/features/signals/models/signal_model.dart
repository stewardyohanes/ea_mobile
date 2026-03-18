class Signal {
  final String id;
  final String pair; // e.g. 'XAUUSD', 'EURUSD'
  final String direction; // 'BUY' | 'SELL'
  final String status; // 'active' | 'tp_hit' | 'sl_hit' | 'closed'
  final double entryPrice;
  final double stopLoss;
  final double takeProfit1;
  final double? takeProfit2;
  final double? takeProfit3;
  final int? riskRewardRatio;
  final String? notes;
  final String createdAt;
  final String? closedAt;

  const Signal({
    required this.id,
    required this.pair,
    required this.direction,
    required this.status,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit1,
    this.takeProfit2,
    this.takeProfit3,
    this.riskRewardRatio,
    this.notes,
    required this.createdAt,
    this.closedAt,
  });

  factory Signal.fromJson(Map<String, dynamic> json) {
    return Signal(
      id: json['id'].toString(),
      pair: json['pair'] as String,
      direction: json['direction'] as String,
      status: json['status'] as String,
      entryPrice: (json['entry_price'] as num).toDouble(),
      stopLoss: (json['stop_loss'] as num).toDouble(),
      takeProfit1: (json['take_profit_1'] as num).toDouble(),
      takeProfit2: (json['take_profit_2'] as num?)?.toDouble(),
      takeProfit3: (json['take_profit_3'] as num?)?.toDouble(),
      riskRewardRatio: json['risk_reward_ratio'] as int?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      closedAt: json['closed_at'] as String?,
    );
  }

  // Computed properties — logic langsung di model
  bool get isBuy => direction == 'BUY';
  bool get isActive => status == 'active';
  bool get isTpHit => status == 'tp_hit';
  bool get isSlHit => status == 'sl_hit';
}
