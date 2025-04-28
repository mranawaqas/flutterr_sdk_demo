import 'package:mapmetrics/mapmetrics.dart';

class AddressModel {
  String? fullAddress;
  String? shortAddress;
  Position? latLng;
  Address? address;

  AddressModel({
    this.fullAddress,
    this.shortAddress,
    this.latLng,
    this.address,
  });
}

class Address {
  String? city;
  String? country;
  String? line1;
  String? line2;
  String? postal_code;
  String? state;

  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postal_code,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    city: json["city"],
    country: json["country"],
    line1: json["line1"],
    line2: json["line2"],
    postal_code: json["postal_code"],
    state: json["state"],
  );
}
