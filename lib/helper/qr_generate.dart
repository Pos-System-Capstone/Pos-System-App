String vietQrGenerate(num amount, String invoiceId) {
  String qrString =
      "https://img.vietqr.io/image/ACB-13397707-print.png?amount=$amount&addInfo=$invoiceId&accountName=PHAM%20LE%20HUNG";
  return qrString;
}
