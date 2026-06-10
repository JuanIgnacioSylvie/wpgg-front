import 'package:equatable/equatable.dart';

class StoreProduct extends Equatable {
  const StoreProduct({
    required this.id,
    required this.title,
    required this.rpAmount,
    required this.priceWpgg,
    required this.imageAsset,
    this.regionLabel = 'Riot Key GLOBAL',
  });

  final String id;
  final String title;
  final int rpAmount;
  final int priceWpgg;
  final String imageAsset;
  final String regionLabel;

  String get displayName => '$title - $rpAmount RP - $regionLabel';

  @override
  List<Object?> get props => [id, title, rpAmount, priceWpgg, imageAsset, regionLabel];
}
