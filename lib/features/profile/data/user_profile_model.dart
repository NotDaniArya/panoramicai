class UserProfileModel {
  final String Uid;
  final String userName;
  final String photoUrl;
  final String email;
  final String? tanggalLahir;
  final String? institusi;
  final String? npa;

  UserProfileModel({
    required this.Uid,
    required this.userName,
    required this.photoUrl,
    required this.email,
    this.tanggalLahir,
    this.institusi,
    this.npa,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      Uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      email: map['email'] ?? '',
      tanggalLahir: map['tanggalLahir'] ?? '',
      institusi: map['institusi'] ?? '',
      npa: map['npa'] ?? '',
    );
  }
}
