import 'package:flutter_dotenv/flutter_dotenv.dart';

class TTexts {
  static final projectUrl = dotenv.get('PROJECT_URL');
  static final anonKey = dotenv.get('ANON_KEY');
  static final descGigiSulung =
      'Gigi sulung, atau secara medis disebut deciduous teeth, merupakan rangkaian gigi pertama yang tumbuh pada manusia, biasanya dimulai sejak usia enam bulan hingga lengkap berjumlah 20 gigi pada usia tiga tahun. Gigi ini memiliki struktur yang lebih kecil dengan lapisan email dan dentin yang lebih tipis dibandingkan gigi dewasa, sehingga cenderung berwarna lebih putih namun lebih rentan terhadap karies. Fungsi utamanya bukan hanya untuk membantu anak mengunyah dan berbicara, tetapi juga sebagai space maintainer atau pemandu jalan agar gigi permanen dapat tumbuh pada posisi yang tepat di dalam lengkung rahang.';
  static final descGigiPermanent =
      'Gigi permanen, yang dikenal sebagai permanent teeth, adalah set gigi kedua yang mulai muncul menggantikan gigi sulung sekitar usia enam tahun dan idealnya akan bertahan seumur hidup dengan jumlah total 32 gigi. Gigi ini memiliki ukuran yang lebih besar, akar yang lebih panjang dan kuat, serta lapisan email yang jauh lebih tebal untuk menahan beban pengunyahan selama puluhan tahun. Secara visual, gigi permanen biasanya terlihat sedikit lebih gelap atau kekuningan dibandingkan gigi susu karena kepadatan dentin di dalamnya yang lebih tinggi, serta berfungsi krusial dalam menjaga struktur wajah dan artikulasi bicara yang jelas.';
}
