class SymbolStat {
  final String pair;
  final int wins;
  final int losses;
  final int winRate;

  const SymbolStat({
    required this.pair,
    required this.wins,
    required this.losses,
    required this.winRate,
  });

  factory SymbolStat.fromJson(Map<String, dynamic> json) {
    return SymbolStat(
      pair: json['pair'] as String,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
      winRate: json['win_rate'] as int,
    );
  }
}

class MonthlyTrend {
  final String month; // e.g. 'Jan', 'Feb'
  final int winRate;

  const MonthlyTrend({required this.month, required this.winRate});

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) {
    return MonthlyTrend(
      month: json['month'] as String,
      winRate: json['win_rate'] as int,
    );
  }
}

class AnalyticsSummary {
  final int winRate;
  final int wins;
  final int losses;
  final int streak;
  final List<SymbolStat> bySymbol;
  final List<MonthlyTrend> monthlyTrend;

  const AnalyticsSummary({
    required this.winRate,
    required this.wins,
    required this.losses,
    required this.streak,
    required this.bySymbol,
    required this.monthlyTrend,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      winRate: json['win_rate'] as int,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
      streak: json['streak'] as int? ?? 0,
      // List.from + .map() = setara array.map() di JS
      bySymbol: (json['by_symbol'] as List)
          .map((e) => SymbolStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthlyTrend: (json['monthly_trend'] as List)
          .map((e) => MonthlyTrend.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
