extension Extension on Object {
  bool isNullOrEmpty() => this == null || this == '' || this == 'null';

  bool isNullEmptyOrFalse() => this == null || this == 'null' || this == '' || !this;

  bool isNullEmptyZeroOrFalse() =>
      this == null || this == 'null' || this == '' || !this || this == 0;
}

