import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fiksi/features/order/data/models/request_order_model/request_order_model.dart';
import 'package:flutter_fiksi/features/order/data/models/request_order_model/order_item.dart';

void main() {
  group('RequestOrderModel JSON Alignment Test', () {
    test('should generate JSON that matches the expected API structure', () {
      // Create test data that matches your expected JSON
      final orderItems = [
        OrderItem(menuId: 10, quantity: 2, price: 40000),
        OrderItem(menuId: 12, quantity: 1, price: 70000),
      ];

      final requestOrder = RequestOrderModel(
        userId: 1,
        tableId: 2,
        amount: 150000,
        reservationTime: "2025-07-14T19:00:00",
        orderItems: orderItems,
      );

      // Convert to JSON
      final json = requestOrder.toJson();

      // Expected JSON structure
      final expectedJson = {
        "user_id": 1,
        "table_id": 2,
        "amount": 150000,
        "reservation_time": "2025-07-14T19:00:00",
        "order_items": [
          {"menu_id": 10, "quantity": 2, "price": 40000},
          {"menu_id": 12, "quantity": 1, "price": 70000},
        ],
      };

      // Debug output (only for testing)
      // print('Generated JSON:');
      // print(json);
      // print('\nExpected JSON:');
      // print(expectedJson);

      // Verify the structure
      expect(json['user_id'], equals(expectedJson['user_id']));
      expect(json['table_id'], equals(expectedJson['table_id']));
      expect(json['amount'], equals(expectedJson['amount']));
      expect(
        json['reservation_time'],
        equals(expectedJson['reservation_time']),
      );
      expect(json['order_items'], isA<List>());
      expect(json['order_items'].length, equals(2));

      // Verify first order item
      expect(json['order_items'][0]['menu_id'], equals(10));
      expect(json['order_items'][0]['quantity'], equals(2));
      expect(json['order_items'][0]['price'], equals(40000));

      // Verify second order item
      expect(json['order_items'][1]['menu_id'], equals(12));
      expect(json['order_items'][1]['quantity'], equals(1));
      expect(json['order_items'][1]['price'], equals(70000));

      // Debug output (only for testing)
      // print('\n✅ JSON structure matches expected API format!');
    });

    test('should correctly deserialize from JSON', () {
      // Test JSON input
      final jsonInput = {
        "user_id": 1,
        "table_id": 2,
        "amount": 150000,
        "reservation_time": "2025-07-14T19:00:00",
        "order_items": [
          {"menu_id": 10, "quantity": 2, "price": 40000},
          {"menu_id": 12, "quantity": 1, "price": 70000},
        ],
      };

      // Deserialize from JSON
      final requestOrder = RequestOrderModel.fromJson(jsonInput);

      // Verify deserialization
      expect(requestOrder.userId, equals(1));
      expect(requestOrder.tableId, equals(2));
      expect(requestOrder.amount, equals(150000));
      expect(requestOrder.reservationTime, equals("2025-07-14T19:00:00"));
      expect(requestOrder.orderItems, isNotNull);
      expect(requestOrder.orderItems!.length, equals(2));

      // Verify order items
      expect(requestOrder.orderItems![0].menuId, equals(10));
      expect(requestOrder.orderItems![0].quantity, equals(2));
      expect(requestOrder.orderItems![0].price, equals(40000));

      expect(requestOrder.orderItems![1].menuId, equals(12));
      expect(requestOrder.orderItems![1].quantity, equals(1));
      expect(requestOrder.orderItems![1].price, equals(70000));

      // Debug output (only for testing)
      // print('✅ JSON deserialization works correctly!');
    });
  });
}
