import 'package:equatable/equatable.dart';
import '../../domain/entities/bedtime_story.dart';

abstract class BedtimeStoriesState extends Equatable {
  const BedtimeStoriesState();

  @override
  List<Object?> get props => [];
}

class BedtimeStoriesInitial extends BedtimeStoriesState {}

class BedtimeStoriesLoading extends BedtimeStoriesState {}

class BedtimeStoriesLoaded extends BedtimeStoriesState {
  final List<BedtimeStoryEntity> stories;

  const BedtimeStoriesLoaded(this.stories);

  @override
  List<Object?> get props => [stories];
}

class BedtimeStoriesError extends BedtimeStoriesState {
  final String message;

  const BedtimeStoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class BedtimeStorySaved extends BedtimeStoriesState {}
