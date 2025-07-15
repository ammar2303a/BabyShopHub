class OrderItem{
  final String productId;
  final String productName;
  final int quantity;
  final int productPrice;

  const OrderItem({
    required this.productId,required this.productName, required this.quantity, required this.productPrice
});
  Map<String, dynamic> toMap(){
    return{
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'productPrice': productPrice
    };
  }
}

class Orders{
  final String id;
  final List<OrderItem> items;
  final int totalPrice;
  final DateTime timestamp;

  const Orders({
    required this.id, required this.items, required this.totalPrice, required this.timestamp
});
  Map<String, dynamic> toMap(){
   return {
   'items': items.map((item) => item.toMap()).toList(),
     'totalPrice': totalPrice,
     'timestamp': timestamp
   };
  }
}