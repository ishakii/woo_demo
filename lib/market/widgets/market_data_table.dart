import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woo_demo/market/model.dart';
import 'package:woo_demo/market/view.dart';
import 'package:woo_demo/market/widgets/empty_state.dart';
import 'package:woo_demo/market/widgets/search_bar.dart';

import '../../utils/constants.dart';

/// sorting types
enum SortEnum { asc, desc, def }

/// creates a data table and search bar to show coins in a table
class MarketDataTable extends StatefulWidget {
  /// coin data list
  final List<CoinModel> dataList;

  /// current tab of market screen
  final MarketTabEnum currentTab;

  const MarketDataTable({
    Key? key,
    required this.dataList,
    required this.currentTab,
  }) : super(key: key);

  @override
  State<MarketDataTable> createState() => _MarketDataTableState();
}

class _MarketDataTableState extends State<MarketDataTable> {
  /// current sort of column index
  int? _sortColumnIndex;

  /// current type of sort
  SortEnum currentSort = SortEnum.def;

  /// list of coins which filtered for current tab
  List<CoinModel> list = [];

  /// list of coins which found by search query
  List<CoinModel> filteredList = [];

  /// current search query string
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _prepareData();
    _sortWithDefaultRule();
  }

  /// filters all data by current tab
  _prepareData() {
    if (widget.currentTab == MarketTabEnum.spot) {
      list = widget.dataList
          .where((element) => element.type == CoinTypeEnum.spot.text)
          .toList();
    } else if (widget.currentTab == MarketTabEnum.future) {
      list = widget.dataList
          .where((element) => element.type == CoinTypeEnum.future.text)
          .toList();
    } else {
      list = widget.dataList;
    }
    searchQuery = "";
    filteredList.clear();
  }

  @override
  void didUpdateWidget(covariant MarketDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    list = widget.dataList;
  }

  /// handles search with query
  void _search(String query) {
    searchQuery = query;
    setState(() {
      if (query.isEmpty) {
        _prepareData();
      } else {
        filteredList = list
            .where((element) =>
                element.base.contains(query) ||
                element.base.contains(query.toUpperCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MySearchBar(onChanged: _search),
          searchQuery.isNotEmpty && filteredList.isEmpty
              ? const MyEmptyState()
              : DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: currentSort == SortEnum.asc,
                  columns: [
                    DataColumn(
                      label: _headerLabel(
                        text: "Symbol",
                        isOrdered: _sortColumnIndex == 0,
                      ),
                      onSort: (columnIndex, _) {
                        setState(() {
                          if (currentSort == SortEnum.desc) {
                            _sortColumnIndex = null;
                            currentSort = SortEnum.def;
                            _sortWithDefaultRule();
                          } else {
                            _sortColumnIndex = columnIndex;
                            if (currentSort == SortEnum.asc) {
                              currentSort = SortEnum.desc;
                              // sort the data list in Desc
                              list.sort((a, b) {
                                final String aSortText =
                                    a.base + a.quote + a.type;
                                final String bSortText =
                                    b.base + b.quote + b.type;
                                return bSortText.compareTo(aSortText);
                              });
                            } else {
                              currentSort = SortEnum.asc;
                              // sort the data list in Asc
                              // Rule for sorting by Symbol: {base} + {quote} + {type}
                              list.sort((a, b) {
                                final String aSortText =
                                    a.base + a.quote + a.type;
                                final String bSortText =
                                    b.base + b.quote + b.type;
                                return aSortText.compareTo(bSortText);
                              });
                            }
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: _headerLabel(
                        text: "Last Price",
                        isOrdered: _sortColumnIndex == 1,
                      ),
                      numeric: true,
                      onSort: (columnIndex, _) {
                        setState(() {
                          if (currentSort == SortEnum.desc) {
                            _sortColumnIndex = null;
                            currentSort = SortEnum.def;
                            _sortWithDefaultRule();
                          } else {
                            _sortColumnIndex = columnIndex;
                            if (currentSort == SortEnum.asc) {
                              currentSort = SortEnum.desc;
                              // sort the data list in Desc
                              list.sort(
                                  (a, b) => b.lastPrice.compareTo(a.lastPrice));
                            } else {
                              currentSort = SortEnum.asc;
                              // sort the data list in Asc
                              list.sort(
                                  (a, b) => a.lastPrice.compareTo(b.lastPrice));
                            }
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: _headerLabel(
                        text: "Volume",
                        isOrdered: _sortColumnIndex == 2,
                      ),
                      numeric: true,
                      onSort: (columnIndex, _) {
                        setState(() {
                          if (currentSort == SortEnum.desc) {
                            _sortColumnIndex = null;
                            currentSort = SortEnum.def;
                            _sortWithDefaultRule();
                          } else {
                            _sortColumnIndex = columnIndex;
                            if (currentSort == SortEnum.asc) {
                              currentSort = SortEnum.desc;
                              // sort the data list in Desc
                              list.sort((a, b) => b.volume.compareTo(a.volume));
                            } else {
                              currentSort = SortEnum.asc;
                              // sort the data list in Asc
                              list.sort((a, b) => a.volume.compareTo(b.volume));
                            }
                          }
                        });
                      },
                    ),
                  ],
                  rows: searchQuery.isNotEmpty
                      ? filteredList.map((e) => _dataRows(e)).toList()
                      : list.map((e) => _dataRows(e)).toList(),
                ),
        ],
      ),
    );
  }

  /// creates data table header label
  Widget _headerLabel({required String text, required bool isOrdered}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: isOrdered ? Colors.redAccent : null,
      ),
    );
  }

  /// creates data table rows
  DataRow _dataRows(CoinModel coin) {
    return DataRow(
      cells: [
        // Symbol
        DataCell(
          Text(_formatBase(coin)),
        ),
        // Last Price
        DataCell(
          Text("\$${_formatLastPrice(coin.lastPrice)}"),
        ),
        // Volume
        DataCell(
          Text("\$${_abbreviateVolume(coin.volume)}"),
        ),
      ],
    );
  }

  /// this sort is default rule with considering priority list
  /// sorts data list by volume on SPOT and FUTURES tab
  /// sorts data list by base on ALL tab
  void _sortWithDefaultRule() {
    list.sort((a, b) {
      int comparisonResult = widget.currentTab == MarketTabEnum.all
          ? a.base.compareTo(b.base)
          : b.volume.compareTo(a.volume);

      if (highPriorityBaseList.contains(a.base) ||
          highPriorityBaseList.contains(b.base)) {
        comparisonResult = a.base.compareTo(b.base);
        if (comparisonResult == 0) {
          // handle the same {base}, the display order is USDT, USDC, PERP
          comparisonResult = b.type == CoinTypeEnum.future.text &&
                  a.type != CoinTypeEnum.future.text
              ? -1
              : b.type != CoinTypeEnum.future.text &&
                      a.type == CoinTypeEnum.future.text
                  ? 1
                  : b.quote == "USDT"
                      ? 1
                      : -1;
        } else {
          // highPriorityBaseList items are displayed in the highest priority
          if (highPriorityBaseList.contains(a.base) &&
              !highPriorityBaseList.contains(b.base)) {
            comparisonResult = -1;
          }
          if (!highPriorityBaseList.contains(a.base) &&
              highPriorityBaseList.contains(b.base)) {
            comparisonResult = 1;
          }
        }
      }
      return comparisonResult;
    });
  }

  /// format base whether spot or future
  /// returns {base}/{quote} when type is Spot
  /// returns {base}-PERP when type is Futures
  String _formatBase(CoinModel coinModel) {
    String formattedBase = coinModel.base;
    if (coinModel.type == CoinTypeEnum.spot.text) {
      formattedBase = formattedBase + "/" + coinModel.quote;
    } else {
      formattedBase = formattedBase + "-" + "PERP";
    }
    return formattedBase;
  }

  /// format last price of data by thousandths, eg: $38,888.88
  String _formatLastPrice(double lastPrice) {
    final NumberFormat formatter = NumberFormat.decimalPattern("en_US");
    final String formattedLastPrice = formatter.format(lastPrice);
    return formattedLastPrice;
  }

  /// abbreviate the volume data with K/M/B, eg: $123.05K, $4.38M, $12.6B
  String _abbreviateVolume(double volume) {
    final NumberFormat formatter = NumberFormat.compact(locale: "en_US");
    final String formattedVolume = formatter.format(volume);
    return formattedVolume;
  }
}
