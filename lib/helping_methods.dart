import 'dart:convert' hide Codec;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapmetrics/mapmetrics.dart';

import 'AddressModel.dart';
import 'Dialogs.dart';

class HelpingMethods {
  Future<AddressModel?> getAddress(double lat, double lng) async {
    final token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJlN2E1MjQwMi1lY2M3LTQ3MzAtYTUxOS1mZDc5MTMwMTZlNmYiLCJzY29wZSI6WyJtYXBzIiwiYXV0b2NvbXBsZXRlIiwiZ2VvY29kZSJdLCJpYXQiOjE3NDU4MzUyMTR9.VMOKZMLMWjl5G9cl4IoWZiuH9GATF-cpeA2gO7ZEuas';
    final request =
        'https://gateway.mapmetrics.org/v1/reverse?point.lat=$lat&point.lon=$lng&size=1&token=$token';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List featuresJson = jsonResponse['features'] as List;
      final List<Suggestion> addresses =
          featuresJson.map((feature) => Suggestion.fromJson(feature)).toList();
      if (addresses.isNotEmpty) {
        return AddressModel(
          fullAddress: addresses.first.label,
          shortAddress: addresses.first.name,
          address: Address(
            city: addresses.first.locality,
            country: addresses.first.country,
            state: addresses.first.state,
            line1: addresses.first.street,
            line2: addresses.first.locality ?? "",
            postal_code: "00000",
          ),
          latLng: Position(lng, lat),
        );
      }
      return AddressModel(
        fullAddress: "",
        shortAddress: "",
        address: Address(
          city: "",
          country: "",
          state: "",
          line1: "",
          line2: "",
          postal_code: "00000",
        ),
        latLng: Position(lng, lat),
      );
    } else {
      throw Exception(
        'Failed to fetch properties. Status Code: ${response.statusCode}',
      );
    }
  }

  Widget permissionDialog({
    required String title,
    required String content,
    String? rightBtnText,
    required Function rightBtn,
    String? leftBtnText,
    Function? leftBtn,
    required BuildContext context,
  }) {
    return Dialogs.alertDialog(
      title: title,
      height: 13,
      width: 10,
      content: content,
      leftBtnText: leftBtnText!,
      rightBtnText: rightBtnText!,
      rightBtnTap: rightBtn,
      leftBtnTap:
          leftBtn ??
          () {
            Navigator.pop(context);
          },
    );
  }
}

class Suggestion {
  final String? name;
  final String? label;
  final String? street;
  final String? locality;
  final String? country;
  final String? state;
  final List<double> coordinates;

  Suggestion({
    this.name,
    this.label,
    this.locality,
    this.country,
    this.street,
    this.state,
    required this.coordinates,
  });

  // The factory constructor now expects the whole feature JSON,
  // extracting both properties and the geometry details.
  factory Suggestion.fromJson(Map<String, dynamic> featureJson) {
    final Map<String, dynamic> propertiesJson =
        featureJson['properties'] as Map<String, dynamic>;
    final Map<String, dynamic> geometryJson =
        featureJson['geometry'] as Map<String, dynamic>;

    // Extract and convert the coordinates to a List<double>
    final List<double> coords = List<double>.from(
      (geometryJson['coordinates'] as List).map((e) => (e as num).toDouble()),
    );

    return Suggestion(
      name: propertiesJson['name'],
      label: propertiesJson['label'],
      locality: propertiesJson['locality'],
      country: propertiesJson['country'],
      street: propertiesJson['borough'],
      state: propertiesJson['region'],
      coordinates: coords,
    );
  }

  @override
  String toString() {
    return 'Suggestion(label: $label, name: $name)';
  }
}
