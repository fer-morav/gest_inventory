import 'dart:convert';

class Address {
  int cp;
  String state;
  String town;
  String suburb;
  String street;
  int num;

  Address({
    this.cp = 0,
    this.state = '',
    this.town = '',
    this.suburb = '',
    this.street = '',
    this.num = 0,
  });

  Address copyWith({
    int? cp,
    String? state,
    String? town,
    String? suburb,
    String? street,
    int? num,
  }) {
    return Address(
      cp: cp ?? this.cp,
      state: state ?? this.state,
      town: town ?? this.town,
      suburb: suburb ?? this.suburb,
      street: street ?? this.street,
      num: num ?? this.num,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cp': this.cp,
      'state': this.state,
      'town': this.town,
      'suburb': this.suburb,
      'street': this.street,
      'num': this.num,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      cp: map['cp'] as int,
      state: map['state'] as String,
      town: map['town'] as String,
      suburb: map['suburb'] as String,
      street: map['street'] as String,
      num: map['num'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Address( cp: $cp, state: $state, town: $town, suburb: $suburb, street: $street, num: $num, )';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Address &&
              runtimeType == other.runtimeType &&
              cp == other.cp &&
              state == other.state &&
              town == other.town &&
              suburb == other.suburb &&
              street == other.street &&
              num == other.num);

  @override
  int get hashCode =>
      cp.hashCode ^
      state.hashCode ^
      town.hashCode ^
      suburb.hashCode ^
      street.hashCode ^
      num.hashCode;
}