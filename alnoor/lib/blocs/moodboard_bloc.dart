// moodboard_bloc.dart
import 'dart:io';

import 'package:alnoor/models/moodboard.dart';
import 'package:alnoor/repositories/moodboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class MoodboardEvent {}

class LoadMoodboards extends MoodboardEvent {
  final String search;

  LoadMoodboards({required this.search});
}

class AddMoodboard extends MoodboardEvent {
  final String moodboardId;
  final String name;
  final File? image1;
  final File? image2;
  final File? image3;
  final File? image4;

  AddMoodboard({
    required this.moodboardId,
    required this.name,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
  });
}

class UpdateMoodboard extends MoodboardEvent {
  final String id;
  final String name;
  final File image1;
  final File image2;
  final File image3;
  final File image4;

  UpdateMoodboard({
    required this.id,
    required this.name,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
  });
}

class DeleteMoodboard extends MoodboardEvent {
  final String id;

  DeleteMoodboard({required this.id});
}

// States
abstract class MoodboardState {}

class MoodboardInitial extends MoodboardState {}

class MoodboardLoading extends MoodboardState {}

class MoodboardLoaded extends MoodboardState {
  final List<Moodboard> moodboards;

  MoodboardLoaded(this.moodboards);
}

class MoodboardAdded extends MoodboardState {}

class MoodboardUpdated extends MoodboardState {}

class MoodboardDeleted extends MoodboardState {}

class MoodboardError extends MoodboardState {
  final String message;

  MoodboardError(this.message);
}

// BLoC
class MoodboardBloc extends Bloc<MoodboardEvent, MoodboardState> {
  final MoodboardsRepository repository;

  MoodboardBloc(this.repository) : super(MoodboardInitial()) {
    on<LoadMoodboards>(_onLoadMoodboards);
    on<AddMoodboard>(_onAddMoodboard);
    on<UpdateMoodboard>(_onUpdateMoodboard);
    on<DeleteMoodboard>(_onDeleteMoodboard);
  }

  Future<void> _onLoadMoodboards(
      LoadMoodboards event, Emitter<MoodboardState> emit) async {
    emit(MoodboardLoading());
    try {
      final moodboards = await repository.fetchMoodboards(event.search);
      emit(MoodboardLoaded(moodboards));
    } catch (e) {
      emit(MoodboardError('Failed to load moodboards'));
    }
  }

  Future<void> _onAddMoodboard(
      AddMoodboard event, Emitter<MoodboardState> emit) async {
    emit(MoodboardLoading());
    try {
      await repository.addMoodboard(
        event.moodboardId,
        event.name,
        event.image1,
        event.image2,
        event.image3,
        event.image4,
      );
      emit(MoodboardAdded());
    } catch (e) {
      emit(MoodboardError('Failed to add moodboard'));
    }
  }

  Future<void> _onUpdateMoodboard(
      UpdateMoodboard event, Emitter<MoodboardState> emit) async {
    emit(MoodboardLoading());
    try {
      await repository.updateMoodboard(
        event.name,
        event.image1,
        event.image2,
        event.image3,
        event.image4,
        event.id,
      );
      emit(MoodboardUpdated());
    } catch (e) {
      emit(MoodboardError('Failed to update moodboard'));
    }
  }

  Future<void> _onDeleteMoodboard(
      DeleteMoodboard event, Emitter<MoodboardState> emit) async {
    try {
      await repository.deleteMoodboard(event.id);
      final moodboards = await repository.fetchMoodboards("");
      emit(MoodboardLoaded(moodboards));
    } catch (e) {
      emit(MoodboardError('Failed to delete moodboard'));
    }
  }
}
