import 'package:flutter/material.dart';

import '../src/demo_data.dart';
import 'model.dart';
import 'widgets/market_data_table.dart';

/// market tab names
enum MarketTabEnum { all, spot, future }

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  /// Name of the tabs
  static const List<String> _tabNames = ["ALL", "SPOT", "FUTURES"];

  /// Serialized data of demoData
  late List<CoinModel> dataList = [];

  @override
  void initState() {
    super.initState();
    dataList = demoData.map((e) => CoinModel.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabNames.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: _tabNames.map((e) => Tab(text: e)).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            MarketDataTable(dataList: dataList, currentTab: MarketTabEnum.all),
            MarketDataTable(dataList: dataList, currentTab: MarketTabEnum.spot),
            MarketDataTable(
                dataList: dataList, currentTab: MarketTabEnum.future),
          ],
        ),
      ),
    );
  }
}
