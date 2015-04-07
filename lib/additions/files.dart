library additions.files;

String getSourceFileName(String src) =>
  src.split("/").last.split(".").first;
