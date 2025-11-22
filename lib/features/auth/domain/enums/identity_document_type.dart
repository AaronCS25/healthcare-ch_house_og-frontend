enum IdentityDocumentType {
  dni('dni', 'DNI', 'DNI'),
  passport('passport', 'Passport', 'Pasaporte'),
  foreignCard('foreign_card', 'CE', 'Carné de Extranjería');

  const IdentityDocumentType(this.code, this.alias, this.displayName);

  final String code;
  final String alias;
  final String displayName;
}
