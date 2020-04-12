library photo;

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:photo_manager/photo_manager.dart';

import 'package:photo/src/delegate/badge_delegate.dart';
import 'package:photo/src/delegate/checkbox_builder_delegate.dart';
import 'package:photo/src/delegate/loading_delegate.dart';
import 'package:photo/src/delegate/sort_delegate.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/i18n_provider.dart';
import 'package:photo/src/ui/dialog/not_permission_dialog.dart';
import 'package:photo/src/ui/photo_app.dart';
export 'package:photo/src/delegate/checkbox_builder_delegate.dart';
export 'package:photo/src/delegate/loading_delegate.dart';
export 'package:photo/src/delegate/sort_delegate.dart';
export 'package:photo/src/provider/i18n_provider.dart'
    show I18NCustomProvider, I18nProvider, CNProvider, ENProvider;
export 'package:photo/src/entity/options.dart' show PickType;
export 'package:photo/src/delegate/badge_delegate.dart';

class PhotoPicker {
  static PhotoPicker _instance;

  PhotoPicker._();

  factory PhotoPicker() {
    _instance ??= PhotoPicker._();
    return _instance;
  }

  static const String rootRouteName = "photo_picker_image";


  static Future<List<AssetEntity>> pickAsset({
    @required BuildContext context,
    bool isAnimated = false,
    int rowCount = 4,
    int maxSelected = 9,
    double padding = 0.5,
    double itemRadio = 1.0,
    Color themeColor,
    Color dividerColor,
    Color textColor,
    Color disableColor,
    int thumbSize = 64,
    I18nProvider provider = I18nProvider.english,
    SortDelegate sortDelegate,
    CheckBoxBuilderDelegate checkBoxBuilderDelegate,
    LoadingDelegate loadingDelegate,
    PickType pickType = PickType.all,
    BadgeDelegate badgeDelegate = const DefaultBadgeDelegate(),
    List<AssetPathEntity> photoPathList,
    List<AssetEntity> pickedAssetList,
  }) {
    assert(provider != null, "provider must be not null");
    assert(context != null, "context must be not null");
    assert(pickType != null, "pickType must be not null");

    themeColor = Colors.black;
    dividerColor ??= Theme.of(context)?.dividerColor ?? Colors.grey;
    disableColor ??= Theme.of(context)?.disabledColor ?? Colors.grey;
    textColor ??= Colors.white;

    sortDelegate ??= SortDelegate.common;
    checkBoxBuilderDelegate ??= DefaultCheckBoxBuilderDelegate();

    loadingDelegate ??= DefaultLoadingDelegate();

    var options = Options(
      rowCount: rowCount,
      dividerColor: dividerColor,
      maxSelected: maxSelected,
      itemRadio: itemRadio,
      padding: padding,
      disableColor: disableColor,
      textColor: textColor,
      themeColor: themeColor,
      thumbSize: thumbSize,
      sortDelegate: sortDelegate,
      checkBoxBuilderDelegate: checkBoxBuilderDelegate,
      loadingDelegate: loadingDelegate,
      badgeDelegate: badgeDelegate,
      pickType: pickType,
    );

    return PhotoPicker()._pickAsset(
      context,
      options,
      provider,
      photoPathList,
      pickedAssetList,
        isAnimated
    );
  }

  Future<List<AssetEntity>> _pickAsset(
    BuildContext context,
    Options options,
    I18nProvider provider,
    List<AssetPathEntity> photoList,
    List<AssetEntity> pickedAssetList,
      bool isAnimated
  ) async {
    var requestPermission = await PhotoManager.requestPermission();
    if (requestPermission != true) {
      var result = await showDialog(
        context: context,
        builder: (ctx) => NotPermissionDialog(
          provider.getNotPermissionText(options),
        ),
      );
      if (result == true) {
        PhotoManager.openSetting();
      }
      return null;
    }

    return _openGalleryContentPage(
      context,
      options,
      provider,
      photoList,
      pickedAssetList,
        isAnimated
    );
  }

  Future<List<AssetEntity>> _openGalleryContentPage(
    BuildContext context,
    Options options,
    I18nProvider provider,
    List<AssetPathEntity> photoList,
    List<AssetEntity> pickedAssetList,
      bool isAnimated,
  ) async {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (ctx) => PhotoApp(
          options: options,
          provider: provider,
          photoList: photoList,
          pickedAssetList: pickedAssetList,
            isAnimated:isAnimated
        ),
      ),
    );
  }
}
