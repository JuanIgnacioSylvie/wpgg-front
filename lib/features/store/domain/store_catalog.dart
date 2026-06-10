import 'entities/store_product.dart';

abstract final class StoreCatalog {
  static const imageAsset = 'assets/images/lol_gift_card.png';

  static const products = <StoreProduct>[
    StoreProduct(
      id: 'lol-gift-card-100rp',
      title: 'League of Legends Gift Card',
      rpAmount: 100,
      priceWpgg: 3500,
      imageAsset: imageAsset,
    ),
    StoreProduct(
      id: 'lol-gift-card-575rp',
      title: 'League of Legends Gift Card',
      rpAmount: 575,
      priceWpgg: 6000,
      imageAsset: imageAsset,
    ),
  ];
}
