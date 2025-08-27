enum HttpMethod { get, post, put, delete, upload }

class ApiConstants {
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const int _currEnv = 3;

  static const String _local = "http://localhost:8000";
  static const String _emulator = "http://10.0.2.2:8000";
  static String _wifi = "http://10.28.229.212:8000";
  static const String _production = "https://api.myfuelapp.com...";
  static const String _version = "api/v1";

  static  setWifIp(String ip) {
    _wifi = "http://$ip:8000";
  }

  static String get baseUrl {
    switch (_currEnv) {
      case 0:
        return "$_local/$_version";
      case 1:
        return "$_production/$_version";
      case 2:
        return "$_emulator/$_version";
      case 3:
        return "$_wifi/$_version";
      default:
        return "$_local/$_version";
    }
  }

  static final auth = _AuthUrl(baseUrl);
  static final test = _TestUrl(baseUrl);
  static final user = _UserUrl(baseUrl);
  static final role = _RoleUrl(baseUrl);
  static final userRole = _UserRoleUrl(baseUrl);
  static final vehicle = _VehicleUrl(baseUrl);
  static final station = _StationUrl(baseUrl);
  static final booking = _BookingUrl(baseUrl);
  static final reporting = _ReportingUrl(baseUrl);

  static final period = _PeriodUrl(baseUrl);
  static final fuelType = _FuelTypeUrl(baseUrl);
  static final refuel = _RefuelUrl(baseUrl);
  static final stationDailyInfo = _StationDailyInfoUrl(baseUrl);
}

class _AuthUrl {
  final String _base;
  _AuthUrl(this._base);
  late final String group = "$_base/auth";

  String get register => "$group/register";
  String get login => "$group/login";
  String get passwordReset => "$group/password/reset";
  String get passwordChange => "$_base/password/change";
  String get logout => "$group/logout";
}

class _TestUrl {
  final String _base;
  _TestUrl(this._base);
  late final String group = "$_base/test";

  String get test1 => "$group/test1";
  String get index => "$group/";
  String get j => "$group/j";
  String get j1 => "$group/j1";
  String get j2 => "$group/j2";
  String get connection => "$group/connection";
  String get sms => "$group/sms";
}

class _UserUrl {
  final String _base;
  _UserUrl(this._base);
  String get profile => "$_base/user";
}

class _RoleUrl {
  final String _base;
  _RoleUrl(this._base);
  late final String group = "$_base/roles";

  String get index => group;
  String get store => group;
  String show(String id) => "$group/$id";
  String update(String id) => "$group/$id";
  String destroy(String id) => "$group/$id";
  String assignPermission(String id) => "$group/$id/permissions";
  String revokePermission(String id, String permission) =>
      "$group/$id/permissions/$permission";
}

class _UserRoleUrl {
  final String _base;
  _UserRoleUrl(this._base);
  late final String group = "$_base/users";

  String getUserRole(String id) => "$group/getMyRole";
  String getUserRoleAndPermissions() => "$group/getMyRoleAndPermissions";
  String assignRolePermissions() => "$group/assignRolePermissions";
  String assignPermissionForUser() => "$group/assignPermissionForUser";
}

class _VehicleUrl {
  final String _base;
  _VehicleUrl(this._base);
  late final String group = "$_base/vehicles";

  String get link => "$group/link";
  String get unlink => "$group/unlink";
  String get userVehiclesWithDetails => "$group/getUserVehiclesWithDetails";
  String get userVehiclesDropdown => "$group/getUserVehiclesDropdown";
  String get store => "$group/new";
  String update(String id) => "$group/$id";
  String destroy(String id) => "$group/$id";
}

class _StationUrl {
  final String _base;
  _StationUrl(this._base);
  late final String group = "$_base/stations";

  String get dropdown => "$group/dropdown";
  String get addNew => "$group/addNew";
  String get showAll => "$group/showAll";
  String show(String id) => "$group/show/$id";
  String update(String id) => "$group/update/$id";
  String destroy(String id) => "$group/Delete/$id";
}

class _StationDailyInfoUrl {
  final String _base;
  _StationDailyInfoUrl(this._base);
  late final String group = "$_base/station-daily-infos";

  String get showAll => "$group/showAll";
  String get stationsDailyInfoForUser => "$group/StationsDailyInfoForUser";

  String get addNew => "$group/addNew";
  String show(String id) => "$group/show/$id";
  String update(String id) => "$group/update/$id";
  String destroy(String id) => "$group/Delete/$id";

  String getAllStationsDailyInfoForDate({String? date}) {
    if (date != null &&
        date.trim().isNotEmpty &&
        date != "N/A" &&
        date != ".") {
      return "$group/getAllStationsDailyInfoForDate?date=$date";
    }
    return "$group/getAllStationsDailyInfoForDate";
  }
}

class _BookingUrl {
  final String _base;
  _BookingUrl(this._base);
  late final String _group = "$_base/booking";

  String get make => "$_group/make";
  String get cancel => "$_group/cancel";
  String get userBookings => "$_group/history";

  String getBooking(String id) => "$_group/history/$id";
  String get index => _group;
  String get store => _group;
  String show(String id) => "$_group/$id";
  String update(String id) => "$_group/$id";
  String destroy(String id) => "$_group/$id";
}

class _ReportingUrl {
  final String _base;
  _ReportingUrl(this._base);
  late final String _group = "$_base/reporting";

  String get stationDailyInfo => "$_group/station-daily";
  String get bookings => "$_group/bookings";
  String get station => "$_group/history";

  String getBooking(String id) => "$_group/history/$id";
  String get index => _group;
  String get store => _group;
  String show(String id) => "$_group/$id";
  String update(String id) => "$_group/$id";
  String destroy(String id) => "$_group/$id";
}

class _PeriodUrl {
  final String _base;
  _PeriodUrl(this._base);
  late final String group = "$_base/periods";

  String get index => group;
  String get periodsDropdown => "$group/Dropdown";

  String get store => group;
  String show(String id) => "$group/$id";
  String update(String id) => "$group/$id";
  String destroy(String id) => "$group/$id";
}

class _FuelTypeUrl {
  final String _base;
  _FuelTypeUrl(this._base);
  late final String group = "$_base/fuel-types";

  String get index => group;
  String get store => group;
  String show(String id) => "$group/$id";
  String update(String id) => "$group/$id";
  String destroy(String id) => "$group/$id";
}

class _RefuelUrl {
  final String _base;
  _RefuelUrl(this._base);
  late final String group = "$_base/refueling";

  String get refuel => "$group/refuel";
  String get getVehicleInfoByQr => "$group/getVehicleInfoByQr";
}
