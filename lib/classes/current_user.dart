class CurrentUser {
  static String id = "";
  static String nickName = "";
  static String email = "";
  static String photoUrl = "";
  static String marketName = "";

  CurrentUser.setUserProperities({
    required String newId,
    required String newNickName,
    required String newEmail,
    required String newPhotoUrl,
    required String newMarketName,
  }) {
    id = newId;
    nickName = newNickName;
    email = newEmail;
    photoUrl = newPhotoUrl;
    marketName = newMarketName;
  }

  CurrentUser.copyWith({
    String? newId,
    String? newNickName,
    String? newEmail,
    String? newPhotoUrl,
    String? newMarketName,
  }) {
    id = newId ?? id;
    nickName = newNickName ?? nickName;
    email = newEmail ?? email;
    photoUrl = newPhotoUrl ?? photoUrl;
    marketName = newMarketName ?? marketName;
  }
}
