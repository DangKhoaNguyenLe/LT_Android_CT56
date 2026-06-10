import 'package:flutter/material.dart';

import '../../controllers/admin_user_controller.dart';
import '../../models/user_profile.dart';
import '../../utils/app_text.dart';

class ProfilePage extends StatefulWidget {
  final bool isRequiredSetup;

  const ProfilePage({
    super.key,
    this.isRequiredSetup = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AdminUserController controller = AdminUserController();

  late TextEditingController bietDanhController;
  late TextEditingController hoTenController;
  late TextEditingController phoneController;
  late TextEditingController diaChiController;
  late TextEditingController cccdController;

  String avatar = "";

  @override
  void initState() {
    super.initState();

    final profile = controller.getProfile();

    avatar = profile.avatar;
    bietDanhController = TextEditingController(text: profile.bietDanh);
    hoTenController = TextEditingController(text: profile.hoTen);
    phoneController = TextEditingController(text: profile.soDienThoai);
    diaChiController = TextEditingController(text: profile.diaChi);
    cccdController = TextEditingController(text: profile.cccd);
  }

  void chooseAvatar() {
    setState(() {
      avatar = "avatar_admin";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          T.isEnglish
              ? "Avatar selected"
              : "Đã chọn ảnh đại diện mẫu",
        ),
      ),
    );
  }

  void saveProfile() {
    if (bietDanhController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            T.isEnglish
                ? "Display nickname is required"
                : "Bắt buộc nhập biệt danh hiển thị",
          ),
        ),
      );
      return;
    }

    final newProfile = UserProfile(
      avatar: avatar,
      bietDanh: bietDanhController.text.trim(),
      hoTen: hoTenController.text.trim(),
      soDienThoai: phoneController.text.trim(),
      diaChi: diaChiController.text.trim(),
      cccd: cccdController.text.trim(),
    );

    controller.updateProfile(newProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          T.isEnglish
              ? "Account updated successfully"
              : "Cập nhật tài khoản thành công",
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<Locale>(
      valueListenable: T.locale,
      builder: (context, locale, child) {
        return WillPopScope(
          onWillPop: () async {
            if (widget.isRequiredSetup && controller.isProfileLocked()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    T.isEnglish
                        ? "You must set a nickname first"
                        : "Bạn phải thiết lập biệt danh trước",
                  ),
                ),
              );
              return false;
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isRequiredSetup
                    ? T.text("setupAccount")
                    : T.text("profile"),
              ),
              centerTitle: true,
              automaticallyImplyLeading: !widget.isRequiredSetup,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xff08aff0),
                        child: avatar.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 54,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.image,
                                size: 54,
                                color: Colors.white,
                              ),
                      ),

                      const SizedBox(height: 10),

                      OutlinedButton.icon(
                        onPressed: chooseAvatar,
                        icon: const Icon(Icons.camera_alt),
                        label: Text(T.text("changeAvatar")),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: bietDanhController,
                  decoration: InputDecoration(
                    labelText: T.text("nickname"),
                    hintText: T.text("nicknameHint"),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: hoTenController,
                  decoration: InputDecoration(
                    labelText: T.text("fullName"),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: T.text("phone"),
                    helperText: phoneController.text.isEmpty
                        ? T.text("notUpdated")
                        : "${T.text("maskedDisplay")}: ${controller.maskPhone(phoneController.text)}",
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: diaChiController,
                  decoration: InputDecoration(
                    labelText: T.text("address"),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: cccdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: T.text("cccd"),
                    helperText: cccdController.text.isEmpty
                        ? T.text("notUpdated")
                        : "${T.text("maskedDisplay")}: ${controller.maskCCCD(cccdController.text)}",
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff08aff0),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveProfile,
                  child: Text(T.text("saveInfo")),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
