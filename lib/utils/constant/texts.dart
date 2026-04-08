import 'package:flutter_dotenv/flutter_dotenv.dart';

class TTexts {
  static final projectUrl = dotenv.get('PROJECT_URL');
  static final anonKey = dotenv.get('ANON_KEY');

  static final descGigiSulung =
      'Primary teeth, or medically known as deciduous teeth, are the first set of teeth to grow in humans, usually starting at six months of age and ending with a full set of 20 teeth by age three. These teeth are smaller in structure with thinner enamel and dentin layers than adult teeth, so they tend to be whiter in color but more susceptible to decay. Their primary function is not only to help children chew and speak but also to act as space maintainers or guides so that permanent teeth can grow in the correct position within the jaw arch.';
  static final descGigiPermanent =
      'Permanent teeth, also known as permanent teeth, are the second set of teeth that begin to emerge, replacing primary teeth around the age of six and ideally last a lifetime, totaling 32. These teeth are larger, have longer and stronger roots, and have a much thicker enamel layer to withstand decades of chewing. Visually, permanent teeth usually appear slightly darker or yellowish than primary teeth due to the higher dentin density within them, and play a crucial role in maintaining facial structure and clear speech articulation.';

  static final tag_sukses = 'SUCCESS';
  static final tag_warning = 'WARNING';
  static final tag_error = 'ERROR';
}
