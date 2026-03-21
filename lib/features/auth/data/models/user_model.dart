class UserModel {
  final String uid;
  final String email;
  final String? userName;
  final String? photoUrl;
  final String? tanggalLahir;
  final String? institusi;
  final String? npa;

  UserModel({
    required this.uid,
    required this.email,
    this.userName,
    this.photoUrl,
    this.tanggalLahir,
    this.institusi,
    this.npa,
  });

  // map ke object (get data firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      userName: map['userName'],
      photoUrl: map['photoUrl'],
      tanggalLahir: map['tanggalLahir'],
      institusi: map['institusi'],
      npa: map['npa'],
    );
  }

  // object ke map (set data firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'photoUrl': photoUrl,
      'tanggalLahir': tanggalLahir,
      'institusi': institusi,
      'npa': npa,
    };
  }
}
