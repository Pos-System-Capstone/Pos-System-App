import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/screens/settings/promotion_setting_bottom_sheet.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../theme/theme_color.dart';
import '../../../../util/share_pref.dart';
import '../../widgets/other_dialogs/dialog.dart';
import '../../widgets/printer_dialogs/add_bluetooth_printer_dialog.dart';
import '../../widgets/printer_dialogs/add_printer_dialog.dart';
import 'product_atrribute_bottom_sheet.dart';

const double _sectionPadding = 16.0;
const double _sectionSpacing = 16.0;
const double _itemPadding = 12.0;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late RootViewModel rootViewModel;

  @override
  void initState() {
    super.initState();
    rootViewModel = Get.find<RootViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: rootViewModel,
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  _buildThemeSection(),
                  _buildTableSection(model),
                  _buildPrinterSection(),
                  _buildDataSection(),
                  _buildProductSection(),
                  _buildFeaturesSection(model),
                  _buildAccountSection(),
                  SizedBox(height: _sectionSpacing),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(_sectionPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Text(
        "Cài đặt",
        style: Get.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _sectionPadding,
        vertical: _itemPadding,
      ),
      child: Divider(
        thickness: 1,
        color: Get.theme.colorScheme.outlineVariant,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _sectionPadding,
        _sectionSpacing,
        _sectionPadding,
        _itemPadding,
      ),
      child: Text(
        title,
        style: Get.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Get.theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return ScopedModel(
      model: ThemeViewModel(),
      child: ScopedModelDescendant<ThemeViewModel>(
        builder: (context, child, model) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Giao diện"),
              _SwitchSettingItem(
                icon: Icons.dark_mode,
                title: "Chế độ tối",
                value: context.isDarkMode,
                onChanged: (value) => model.toggleTheme(),
              ),
              _ColorPickerItem(model: model),
              _buildSectionDivider(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTableSection(RootViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Bàn hàng"),
        _TableControlItem(model: model),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildPrinterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Máy in"),
        _SettingItem(
          icon: Icons.print,
          title: 'Máy in hoá đơn',
          subtitle: Get.find<PrinterViewModel>().selectedBillPrinter != null
              ? Get.find<PrinterViewModel>().selectedBillPrinter!.url
              : "Chưa kết nối thiết bị",
          onTap: () => showPrinterConfigDialog(PrinterTypeEnum.bill),
        ),
        _SettingItem(
          icon: Icons.print_outlined,
          title: 'Máy in tem',
          subtitle: Get.find<PrinterViewModel>().selectedProductPrinter != null
              ? Get.find<PrinterViewModel>().selectedProductPrinter!.url
              : "Chưa kết nối thiết bị",
          onTap: () => showPrinterConfigDialog(PrinterTypeEnum.stamp),
        ),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Dữ liệu"),
        _SettingItem(
          icon: Icons.refresh,
          title: 'Cập nhật menu',
          subtitle: 'Tải lại danh sách sản phẩm',
          onTap: () => Get.find<MenuViewModel>().getMenuOfStore(),
        ),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Sản phẩm"),
        _SettingItem(
          icon: Icons.edit_attributes,
          title: 'Thuộc tính sản phẩm',
          subtitle: 'Quản lý thuộc tính sản phẩm',
          onTap: () => showProductAttributesBottomSheet(),
        ),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildFeaturesSection(RootViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Tính năng"),
        _SwitchSettingItem(
          icon: Icons.qr_code_2,
          title: 'Quét đơn từ khách hàng',
          value: model.isScanOrder,
          onChanged: (value) => model.setScanOrder(value),
        ),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Tài khoản"),
        _SettingItem(
          icon: Icons.logout,
          title: 'Đăng xuất',
          subtitle: 'Thoát khỏi ứng dụng',
          onTap: () => showConfirmDialog(
            title: "Đăng xuất",
            content: "Bạn có muốn đăng xuất không?",
          ).then((value) {
            if (value) Get.find<LoginViewModel>().logout();
          }),
          isDestructive: true,
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = isDestructive
        ? Get.theme.colorScheme.error
        : Get.theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _sectionPadding,
            vertical: _itemPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 28,
                      color: itemColor,
                    ),
                    SizedBox(width: _itemPadding),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDestructive
                                  ? Get.theme.colorScheme.error
                                  : Get.theme.colorScheme.onSurface,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Get.theme.colorScheme.outlineVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: _itemPadding),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Get.theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _sectionPadding,
        vertical: _itemPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: Get.theme.colorScheme.primary,
              ),
              SizedBox(width: _itemPadding),
              Text(
                title,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ColorPickerItem extends StatelessWidget {
  final ThemeViewModel model;

  const _ColorPickerItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _sectionPadding,
        vertical: _itemPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.colorize,
                size: 28,
                color: Get.theme.colorScheme.primary,
              ),
              SizedBox(width: _itemPadding),
              Text(
                'Màu nền',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          PopupMenuButton(
            tooltip: "Đổi màu sắc",
            icon: Icon(
              Icons.palette,
              color: Get.theme.colorScheme.primary,
              size: 28,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) {
              return List.generate(colorOptions.length, (index) {
                return PopupMenuItem(
                  value: index,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorOptions[index],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(colorText[index]),
                    ],
                  ),
                );
              });
            },
            onSelected: (index) => model.handleColorSelect(index),
          ),
        ],
      ),
    );
  }
}

class _TableControlItem extends StatelessWidget {
  final RootViewModel model;

  const _TableControlItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _sectionPadding,
        vertical: _itemPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.table_restaurant,
                size: 28,
                color: Get.theme.colorScheme.primary,
              ),
              SizedBox(width: _itemPadding),
              Text(
                'Số lượng bàn',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Get.theme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => model.decreaseNumberOfTabele(),
                    icon: Icon(Icons.remove, size: 20),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "${model.numberOfTable}",
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => model.increaseNumberOfTabele(),
                    icon: Icon(Icons.add, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
