import 'package:dartz/dartz.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/repositories/giveaway_repository.dart';
import '../entities/giveaway_entity.dart';

class SubmitGiveaway {
  final GiveawayRepository repository;

  SubmitGiveaway(this.repository);

  ResultFuture<Unit> call(GiveawayEntity params) async {
    return repository.submitGiveaway(params);
  }
}
