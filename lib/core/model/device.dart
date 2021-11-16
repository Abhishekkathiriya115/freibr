class DeviceInfo {
  int id;
  String deviceType;
  String deviceName;
  String deviceId;
  String fcmToken;
  int userId;

  DeviceInfo(
      {this.id,
      this.deviceId,
      this.deviceName,
      this.deviceType,
      this.fcmToken,
      this.userId});

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
        id: json["id"] == null ? null : json["id"],
        deviceId: json["device_id"] == null ? null : json["device_id"],
        deviceName: json["device_name"] == null ? null : json["device_name"],
        deviceType: json["device_type"] == null ? null : json["device_type"],
        fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
        userId: json["other_user_id"] == null ? null : json["other_user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "other_user_id": userId == null ? null : userId,
        "device_id": deviceId == null ? null : deviceId,
        "device_name": deviceName == null ? null : deviceName,
        "device_type": deviceType == null ? null : deviceType,
        "fcm_token": fcmToken == null ? null : fcmToken,
      };
}
