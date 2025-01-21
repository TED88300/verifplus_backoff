import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class OrderInfo {
  OrderInfo(this.id, this.customerId, this.name);
  final int id;
  final int customerId;
  final String name;

}


class OrderInfoDataGridSource extends DataGridSource {
  /// Creates the order data source class with required details.
  OrderInfoDataGridSource() {
    orders =  getOrders(orders, 50);
    buildDataGridRows();
  }

  List<OrderInfo> orders = <OrderInfo>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  void buildDataGridRows() {
    dataGridRows = orders.map<DataGridRow>((OrderInfo order) {
              return DataGridRow(cells: <DataGridCell>[
                DataGridCell<int>(columnName: 'id', value: order.id),
                DataGridCell<int>(columnName: 'customerId', value: order.customerId),
                DataGridCell<String>(columnName: 'name', value: order.name),
              ]);
          }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color backgroundColor = Colors.transparent;
      return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[2].value.toString(),
          ),
        ),


      ]);

  }



  List<OrderInfo> getOrders(List<OrderInfo> orderData, int count) {

    for (int i = 0; i < count; i++) {
      orderData.add(OrderInfo(
        1000 + i,
        1700 + i,
        "aaaa",

      ));
    }
    return orderData;
  }
}
