class ProductTypeEnum {
  static const String SINGLE = 'SINGLE';
  static const String PARENT = 'PARENT';
  static const String CHILD = 'CHILD';
  static const String EXTRA = 'EXTRA';
}

class ProductSizeEnum {
  static const String SMALL = 'S';
  static const String MEDIUM = 'M';
  static const String LARGE = 'L';
}

class ProductNoteEnum {
  SugarNoteEnums sugar = SugarNoteEnums();
  IceNoteEnums ice = IceNoteEnums();
}

class SugarNoteEnums {
  static const String SUGAR_100 = 'Đường 100%';
  static const String SUGAR_70 = 'Đường 70%';
  static const String SUGAR_50 = 'Đường 50%';
  static const String SUGAR_30 = 'Đường 30%';
  static const String SUGAR_0 = 'Đường 0%';
}

class IceNoteEnums {
  static const String ICE_100 = 'Đá 100%';
  static const String ICE_70 = 'Đá 70%';
  static const String ICE_50 = 'Đá 50%';
  static const String ICE_30 = 'Đá 30%';
  static const String ICE_0 = 'Đá 0%';
}

List<String> sugarNoteEnums = [
  SugarNoteEnums.SUGAR_100,
  SugarNoteEnums.SUGAR_70,
  SugarNoteEnums.SUGAR_50,
  SugarNoteEnums.SUGAR_30,
  SugarNoteEnums.SUGAR_0,
];
List<String> iceNoteEnums = [
  IceNoteEnums.ICE_100,
  IceNoteEnums.ICE_70,
  IceNoteEnums.ICE_50,
  IceNoteEnums.ICE_30,
  IceNoteEnums.ICE_0,
];

class CategoryTypeEnum {
  static const String Normal = 'Normal';
  static const String Extra = 'Extra';
}
