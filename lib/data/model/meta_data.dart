class MetaDataDTO {
  int? page;
  int? size;
  int? total;

  MetaDataDTO({this.page, this.size, this.total});

  factory MetaDataDTO.fromJson(dynamic json) {
    return MetaDataDTO(
        page: json['page'], size: json['size'], total: json['total']);
  }
}
