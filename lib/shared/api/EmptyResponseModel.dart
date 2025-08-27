import 'package:my_fuel/shared/helper/Parser.dart';

class EmptyResponseModel {
  final int? verifyCode;
  final String? qrCode;

  const EmptyResponseModel({this.verifyCode, this.qrCode});

  factory EmptyResponseModel.fromJson(Map<String, dynamic> json) {
    return EmptyResponseModel(
      verifyCode: Parser.parseInt(json['verify_code']),
      qrCode: Parser.parseString(json['qr_code']),
    );
  }

  Map<String, dynamic> toJson() => {'code': verifyCode};

  @override
  String toString() => 'EmptyResponseModel(code: $verifyCode)';
}
