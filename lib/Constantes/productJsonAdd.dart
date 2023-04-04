class productJsonAdd {
  List<Products>? products;
  List<Null>? discounts;
  String? shippingCost;
  int? shippingCostFloat;
  String? wrappingCost;
  int? nbTotalProducts;
  String? total;
  String? productTotal;
  String? freeShipping;
  int? freeShippingFloat;
  bool? hasError;
  String? crossSelling;

  productJsonAdd(
      {this.products,
        this.discounts,
        this.shippingCost,
        this.shippingCostFloat,
        this.wrappingCost,
        this.nbTotalProducts,
        this.total,
        this.productTotal,
        this.freeShipping,
        this.freeShippingFloat,
        this.hasError,
        this.crossSelling});

  productJsonAdd.fromJson(Map<String, dynamic> json) {
    nbTotalProducts = json['nbTotalProducts'];
    total = json['total'];
    productTotal = json['productTotal'];
  }

}

class Products {
  int? id;
  String? link;
  int? quantity;
  String? image;
  String? imageCart;
  String? priceByLine;
  String? name;
  String? price;
  double? priceFloat;
  int? idCombination;
  int? idAddressDelivery;
  bool? isGift;
  bool? hasAttributes;
  bool? hasCustomizedDatas;
  List<Null>? customizedDatas;

  Products(
      {this.id,
        this.link,
        this.quantity,
        this.image,
        this.imageCart,
        this.priceByLine,
        this.name,
        this.price,
        this.priceFloat,
        this.idCombination,
        this.idAddressDelivery,
        this.isGift,
        this.hasAttributes,
        this.hasCustomizedDatas,
        this.customizedDatas});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    quantity = json['quantity'];
    image = json['image'];
    imageCart = json['image_cart'];
    priceByLine = json['priceByLine'];
    name = json['name'];
    price = json['price'];
    priceFloat = json['price_float'];
    idCombination = json['idCombination'];
    idAddressDelivery = json['idAddressDelivery'];
    isGift = json['is_gift'];
    hasAttributes = json['hasAttributes'];
    hasCustomizedDatas = json['hasCustomizedDatas'];

  }


}
