import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class MaternalHouse {
  const MaternalHouse({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.contactName,
    this.contactMobile,
  });

  factory MaternalHouse.fromJson(Map<String, dynamic> json) {
    return MaternalHouse(
      id: readInt(json, ['id']),
      addressLine1: readString(json, ['address_line1', 'address']),
      addressLine2: readString(json, ['address_line2']),
      city: readString(json, ['city']),
      state: readString(json, ['state']),
      pincode: readString(json, ['pincode', 'postal_code']),
      contactName: readString(json, ['contact_name', 'name']),
      contactMobile: readString(json, ['contact_mobile', 'mobile', 'phone']),
    );
  }

  final int? id;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? pincode;
  final String? contactName;
  final String? contactMobile;

  bool get isEmpty =>
      [addressLine1, city, contactName, contactMobile]
          .every((v) => v == null || v.isEmpty);

  String get fullAddress {
    final parts = [
      addressLine1,
      addressLine2,
      city,
      state,
      pincode,
    ].whereType<String>().where((v) => v.isNotEmpty);
    return parts.join(', ');
  }

  Map<String, dynamic> toPayload() {
    return {
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pincode != null) 'pincode': pincode,
      if (contactName != null) 'contact_name': contactName,
      if (contactMobile != null) 'contact_mobile': contactMobile,
    };
  }
}
