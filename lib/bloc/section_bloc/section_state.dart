part of 'section_bloc.dart';

abstract class SectionState extends Equatable {
  const SectionState();
}

class SectionInitial extends SectionState {
  @override
  List<Object> get props => [];
}
class SectionLoading extends SectionState {
  @override
  List<Object> get props => [];
}

class SectionLoadingSuccess extends SectionState{
  final List<Section> sections;
  const SectionLoadingSuccess({required this.sections});
  @override
  List<Object?> get props => [sections];
}

class SectionLoadingFailure extends SectionState{
  final String message;
  const SectionLoadingFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SectionsAreEmpty extends SectionState{
  final String message;
  const SectionsAreEmpty({required this.message});

  @override
  List<Object?> get props => [message];
}

class SectionRemovingFailure extends SectionState{
  final String message;
  const SectionRemovingFailure({required this.message});

  @override
  List<Object?> get props => [message];

}