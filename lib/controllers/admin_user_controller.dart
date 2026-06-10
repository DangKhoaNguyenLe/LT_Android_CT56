import '../models/user_profile.dart';

class AdminUserController {
  static final UserProfile _profile = UserProfile();

  UserProfile getProfile() {
    return _profile;
  }

  bool isProfileLocked() {
    return _profile.bietDanh.trim().isEmpty;
  }

  void updateProfile(UserProfile profile) {
    _profile.avatar = profile.avatar;
    _profile.bietDanh = profile.bietDanh;
    _profile.hoTen = profile.hoTen;
    _profile.soDienThoai = profile.soDienThoai;
    _profile.diaChi = profile.diaChi;
    _profile.cccd = profile.cccd;
  }

  String maskPhone(String phone) {
    if (phone.trim().isEmpty) return "Chưa cập nhật";
    if (phone.length < 4) return phone;
    return "${phone.substring(0, 3)}******${phone.substring(phone.length - 2)}";
  }

  String maskCCCD(String cccd) {
    if (cccd.trim().isEmpty) return "Chưa cập nhật";
    if (cccd.length < 4) return cccd;
    return "********${cccd.substring(cccd.length - 4)}";
  }

  void logout() {}
}
