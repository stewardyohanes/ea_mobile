class Signal {
  final String id;
  final String? eaSignalId;
  final int? eaTicket;
  final String symbol;
  final String direction; // 'BUY' | 'SELL'
  final String
  status; // 'pending' | 'active' | 'triggered' | 'replaced' | 'tp_hit' | 'sl_hit' | 'closed' | 'cancelled'
  final double entry1;
  final double? entry2;
  final double sl;
  final double? tp;
  final String trend;
  final double? riskReward;
  final double?
  triggeredPrice; // exit price from CLOSED event (triggered_price)
  final double? pips;
  final String createdAt;
  final String? updatedAt;

  const Signal({
    required this.id,
    this.eaSignalId,
    this.eaTicket,
    required this.symbol,
    required this.direction,
    required this.status,
    required this.entry1,
    this.entry2,
    required this.sl,
    this.tp,
    required this.trend,
    this.riskReward,
    this.triggeredPrice,
    this.pips,
    required this.createdAt,
    this.updatedAt,
  });

  factory Signal.fromJson(Map<String, dynamic> json) {
    return Signal(
      id: json['id'].toString(),
      eaSignalId: json['ea_signal_id'] as String?,
      eaTicket: (json['ea_ticket'] as num?)?.toInt(),
      symbol: json['symbol'] as String,
      direction: json['direction'] as String,
      status: json['status'] as String,
      entry1: (json['entry1'] as num).toDouble(),
      entry2: (json['entry2'] as num?)?.toDouble(),
      sl: (json['sl'] as num).toDouble(),
      tp: (json['tp'] as num?)?.toDouble(),
      trend: json['trend'] as String? ?? '',
      riskReward: (json['risk_reward'] as num?)?.toDouble(),
      triggeredPrice: (json['triggered_price'] as num?)?.toDouble(),
      pips: (json['pips'] as num?)?.toDouble(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }

  bool get isBuy => direction == 'BUY';
  bool get isPending => status == 'pending';
  bool get isActive => status == 'active' || status == 'triggered';
  bool get isTriggered => status == 'triggered';
  bool get isReplaced => status == 'replaced';
  bool get isTpHit => status == 'tp_hit';
  bool get isSlHit => status == 'sl_hit';
  bool get isClosed => status == 'closed';
  bool get isCancelled => status == 'cancelled';
  bool get isInFeed => isPending || isActive;
  bool get isCompleted =>
      isReplaced || isTpHit || isSlHit || isClosed || isCancelled;

  // For closed signals: BUY wins if exit > entry1, SELL wins if exit < entry1
  bool get isClosedWin {
    if (!isClosed || triggeredPrice == null || triggeredPrice! <= 0) return false;
    return isBuy ? triggeredPrice! > entry1 : triggeredPrice! < entry1;
  }
}
