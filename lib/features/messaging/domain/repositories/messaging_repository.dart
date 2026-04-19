import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/message_entity.dart';

abstract class IMessagingRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessageThreads();
  Future<Either<Failure, List<MessageEntity>>> getMessages(String roomId);
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message);
  Stream<List<MessageEntity>> streamMessages(String roomId);
  Future<Either<Failure, ({String objectKey, String mediaKey})>> uploadMedia(File file, String roomId);
  Future<Either<Failure, String>> getOrCreateRoom(String otherUserId);
}
