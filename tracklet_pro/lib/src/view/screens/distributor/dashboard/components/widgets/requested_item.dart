import 'package:tracklet_pro/src/model/requested_item.dart' as model;

class RequestedItem {
  final double weight;
  final int quantity;

  RequestedItem({
    required this.weight,
    required this.quantity,
  });

  // Factory constructor to create from model
  factory RequestedItem.fromModel(model.RequestedItem item) {
    return RequestedItem(
      weight: item.weight,
      quantity: item.quantity,
    );
  }

  // Convert to model
  model.RequestedItem toModel() {
    return model.RequestedItem(
      weight: weight,
      quantity: quantity,
    );
  }
}