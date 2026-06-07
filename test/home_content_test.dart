// Unit test for the home page seed content.
import 'package:flutter_test/flutter_test.dart';

import 'package:uni_edu_mobile/data/home_content.dart';
import 'package:uni_edu_mobile/models/how_it_works_step.dart';

void main() {
  group('HomeContent', () {
    test('has 8 features', () {
      expect(HomeContent.features.length, 8);
    });

    test('has all 12 subjects', () {
      expect(HomeContent.subjects.length, 12);
    });

    test('each how-it-works flow has 4 steps', () {
      expect(HomeContent.tutorSteps.length, 4);
      expect(HomeContent.studentSteps.length, 4);
    });

    test('stepsFor returns the matching flow', () {
      expect(
        HomeContent.stepsFor(HowItWorksAudience.tutor),
        same(HomeContent.tutorSteps),
      );
      expect(
        HomeContent.stepsFor(HowItWorksAudience.student),
        same(HomeContent.studentSteps),
      );
    });
  });
}
