import 'package:flutter/material.dart';
import 'package:chinese_lunar_calendar/chinese_lunar_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '中国农历日历',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const LunarCalendarApp(),
    );
  }
}

class LunarCalendarApp extends StatefulWidget {
  const LunarCalendarApp({super.key});

  @override
  State<LunarCalendarApp> createState() => _LunarCalendarAppState();
}

class _LunarCalendarAppState extends State<LunarCalendarApp> {
  late LunarCalendar _lunarCalendar;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _lunarCalendar = LunarCalendar.from(
      utcDateTime: _selectedDate.toUtc(),
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _lunarCalendar = LunarCalendar.from(
        utcDateTime: date.toUtc(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('中国农历日历'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateCard(),
            const SizedBox(height: 24),
            _buildCalendarGrid(),
            const SizedBox(height: 24),
            _buildLunarInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _lunarCalendar.lunarDate.fullCNString,
              style: TextStyle(
                fontSize: 24,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '星期${_lunarCalendar.weekday.name}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month - 1,
                        1,
                      );
                      _lunarCalendar = LunarCalendar.from(
                        utcDateTime: _selectedDate.toUtc(),
                      );
                    });
                  },
                ),
                Text(
                  '${_selectedDate.year}年${_selectedDate.month}月',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month + 1,
                        1,
                      );
                      _lunarCalendar = LunarCalendar.from(
                        utcDateTime: _selectedDate.toUtc(),
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              itemCount: 49, // 7 days header + 42 days max
              itemBuilder: (context, index) {
                if (index < 7) {
                  return Center(
                    child: Text(
                      ['日', '一', '二', '三', '四', '五', '六'][index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }

                final dayIndex = index - 7;
                if (dayIndex < startWeekday || dayIndex >= startWeekday + lastDayOfMonth.day) {
                  return const SizedBox.shrink();
                }

                final day = dayIndex - startWeekday + 1;
                final date = DateTime(_selectedDate.year, _selectedDate.month, day);
                final lunarDate = LunarCalendar.from(
                  utcDateTime: date.toUtc(),
                );
                final isSelected = date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;
                final isToday = date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;

                return InkWell(
                  onTap: () => _onDateSelected(date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : isToday
                              ? Colors.red[100]
                              : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontWeight: isToday || isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : null,
                          ),
                        ),
                        Text(
                          lunarDate.lunarDate.lunarDayCN,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white70
                                : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLunarInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '农历信息',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('农历年', _lunarCalendar.lunarDate.lunarYear.lunarYearCN),
            _buildInfoRow('农历月', '${_lunarCalendar.lunarDate.lunarMonth.leapMonthPrefix}${_lunarCalendar.lunarDate.lunarMonth.lunarMonthCN}${_lunarCalendar.lunarDate.lunarMonth.monthLengthSuffix}'),
            _buildInfoRow('农历日', _lunarCalendar.lunarDate.lunarDayCN),
            _buildInfoRow('生肖', _lunarCalendar.zodiac.name.getValue()),
            _buildInfoRow('干支年', _lunarCalendar.year8Char),
            _buildInfoRow('干支月', _lunarCalendar.month8Char),
            _buildInfoRow('干支日', _lunarCalendar.day8Char),
            _buildInfoRow('节气', _selectedDate.getSolarTerm()?.toString() ?? '无'),
            _buildInfoRow('月相', _lunarCalendar.moonPhase.name.getValue()),
            _buildInfoRow('时辰', _lunarCalendar.twoHourPeriod.name),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}