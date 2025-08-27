import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Controllers/PermissionsController.dart';
import 'package:my_fuel/features/home/widgets/AdminSection.dart';
import 'package:my_fuel/features/home/widgets/ImageCarousel.dart';
import 'package:my_fuel/features/home/widgets/ManagerSection.dart';
import 'package:my_fuel/features/home/widgets/UserSection.dart';
import 'package:my_fuel/features/home/widgets/WorkerSection.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';
import 'package:my_fuel/features/home/widgets/HomeDrawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PermissionsController controller = Get.put(
    PermissionsController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_gas_station),
            const SizedBox(width: 20),
            Text('وقــــــــودي', style: AppTextStyles.appBarTitle),
          ],
        ),
        centerTitle: true,
        actions: [
          //TODO
          /*  IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => AppRoutes.goTo(AppRoutes.alertsTest),
          ), */
        ],
      ),
      drawer: HomeDrawer(),
      body: _buildBody(),
      /*    floatingActionButton: Obx(() {
        if (controller.isLoading) {
          return const FloatingActionButton(
            onPressed: null,
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final roleKey = controller.permissions?.role?.key;

        return FloatingActionButton(
          tooltip: 'إضافة جديد',
          onPressed: () {
            switch (roleKey) {
              case "admin":
                AppRoutes.goTo("admin_dashboard");
                break;
              case "station_manager":
                AppRoutes.goTo("manager_tools");
                break;
              case "worker":
                AppRoutes.goTo("worker_tasks");
                break;
              default:
                Get.snackbar(
                  'لا توجد صلاحيات',
                  'ليس لديك صلاحيات للوصول إلى هذه الأدوات.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  icon: const Icon(Icons.block, color: Colors.white),
                );
            }
          },
          child: const Icon(Icons.add),
        );
      }),
     */
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final roleKey = controller.permissions?.role?.key;

      return RefreshIndicator(
        onRefresh: controller.fetchPermissions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const ImageCarousel(),

              const SizedBox(height: 16),

              if (roleKey == null) ...[
                const SizedBox(height: 40),
                const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'لا توجد صلاحيات متاحة لك حاليًا.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
               

                const SizedBox(height: 40),
              ] else ...[
                //  const TestSection(),
                if (roleKey == "admin") ...[
                  //   const UserSection(),
                  //  const SizedBox(height: 16),
                  //   const WorkerSection(),
                  //   const SizedBox(height: 16),
                  // ManagerSection(),
                  ///  const SizedBox(height: 16),
                  const AdminSection(),
                ] else if (roleKey == "station_manager") ...[
                  // const WorkerSection(),
                  const SizedBox(height: 16),
                  ManagerSection(),
                ] else if (roleKey == "station_worker") ...[
                  const SizedBox(height: 16),
                  const WorkerSection(),
                ] else if (roleKey == "user") ...[
                  const UserSection(),
                ],
              ],
            ],
          ),
        ),
      );
    });
  }
}
