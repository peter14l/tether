import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/circle_repository.dart';
import 'circle_member_state.dart';

@injectable
class CircleMemberCubit extends Cubit<CircleMemberState> {
  final ICircleRepository _circleRepository;

  CircleMemberCubit(this._circleRepository) : super(CircleMemberInitial());

  Future<void> loadMembers(String circleId) async {
    emit(CircleMemberLoading());
    final result = await _circleRepository.getCircleMembers(circleId);
    result.fold(
      (failure) => emit(CircleMemberError(failure.message)),
      (members) => emit(CircleMemberLoaded(members)),
    );
  }
}
