import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/messaging_repository.dart';
import 'messaging_thread_state.dart';

@injectable
class MessagingThreadCubit extends Cubit<MessagingThreadState> {
  final IMessagingRepository _messagingRepository;

  MessagingThreadCubit(this._messagingRepository) : super(MessagingThreadInitial());

  Future<void> loadThreads() async {
    emit(MessagingThreadLoading());
    final result = await _messagingRepository.getMessageThreads();
    result.fold(
      (failure) => emit(MessagingThreadError(failure.message)),
      (threads) => emit(MessagingThreadLoaded(threads)),
    );
  }
}
