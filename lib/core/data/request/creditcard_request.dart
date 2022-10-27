import 'dart:convert';

class CreditCardRequest {
  final String dado1;
  final String dado2;
  final String dado3;
  final String dado4;
  final String dado5;
  final String dado6;
  final String dado7;
  final String dado8;
  final String dado9;
  final String dado10;
  final String dado11;
  final String dado12;
  final String dado13;
  final String dado14;
  final String dado15;

  CreditCardRequest(
      {this.dado1,
      this.dado2,
      this.dado3,
      this.dado4,
      this.dado5,
      this.dado6,
      this.dado7,
      this.dado8,
      this.dado9,
      this.dado10,
      this.dado11,
      this.dado12,
      this.dado13,
      this.dado14,
      this.dado15});

  CreditCardRequest copyWith(
      {String dado1,
      String dado2,
      String dado3,
      String dado4,
      String dado5,
      String dado6,
      String dado7,
      String dado8,
      String dado9,
      String dado10,
      String dado11,
      String dado12,
      String dado13,
      String dado14,
      String dado15}) {
    return CreditCardRequest(
      dado1: dado1 ?? this.dado1,
      dado2: dado2 ?? this.dado2,
      dado3: dado3 ?? this.dado3,
      dado4: dado4 ?? this.dado4,
      dado5: dado5 ?? this.dado5,
      dado6: dado6 ?? this.dado6,
      dado7: dado7 ?? this.dado7,
      dado8: dado8 ?? this.dado8,
      dado9: dado9 ?? this.dado9,
      dado10: dado10 ?? this.dado10,
      dado11: dado11 ?? this.dado11,
      dado12: dado12 ?? this.dado12,
      dado13: dado13 ?? this.dado13,
      dado14: dado14 ?? this.dado14,
      dado15: dado15 ?? this.dado15,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dado1': dado1,
      'dado2': dado2,
      'dado3': dado3,
      'dado4': dado4,
      'dado5': dado5,
      'dado6': dado6,
      'dado7': dado7,
      'dado8': dado8,
      'dado9': dado9,
      'dado10': dado10,
      'dado11': dado11,
      'dado12': dado12,
      'dado13': dado13,
      'dado14': dado14,
      'dado15': dado15,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CreditCardRequest &&
        o.dado1 == dado1 &&
        o.dado2 == dado2 &&
        o.dado3 == dado3 &&
        o.dado4 == dado4 &&
        o.dado5 == dado5 &&
        o.dado6 == dado6 &&
        o.dado7 == dado7 &&
        o.dado8 == dado8 &&
        o.dado9 == dado9 &&
        o.dado10 == dado10 &&
        o.dado11 == dado11 &&
        o.dado12 == dado12 &&
        o.dado13 == dado13 &&
        o.dado14 == dado14 &&
        o.dado15 == dado15;
  }

  @override
  int get hashCode {
    return dado1.hashCode ^
        dado2.hashCode ^
        dado3.hashCode ^
        dado4.hashCode ^
        dado5.hashCode ^
        dado6.hashCode ^
        dado7.hashCode ^
        dado8.hashCode ^
        dado9.hashCode ^
        dado10.hashCode ^
        dado11.hashCode ^
        dado12.hashCode ^
        dado13.hashCode ^
        dado14.hashCode ^
        dado15.hashCode;
  }
}
