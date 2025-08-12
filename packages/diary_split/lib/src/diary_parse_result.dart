/// 日记解析的结果
class DiaryParseResult {
  /// 日记标题
  final String title;

  /// 日记开始时间
  final DateTime? start;

  /// 日记结束时间
  final DateTime? end;

  /// 日记中发现的第一个时间
  final DateTime? first;

  const DiaryParseResult({
    required this.title,
    this.start,
    this.end,
    this.first,
  });
}
