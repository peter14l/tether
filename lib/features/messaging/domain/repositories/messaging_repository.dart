import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/message_entity.dart';

abstract class IMessagingRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessageThreads();
  Future<Either<Failure, List<MessageEntity>>> getMessages(String receiverId, {String? circleId});
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message);
  Stream<List<MessageEntity>> streamMessages(String receiverId, {String? circleId});
  Future<Either<Failure, String>> uploadVoiceNote(File file);
}
