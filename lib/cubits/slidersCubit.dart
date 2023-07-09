import 'package:eschool_teacher/data/models/sliderDetails.dart';
import 'package:eschool_teacher/data/repositories/systemInfoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SlidersState {}

class SlidersInitial extends SlidersState {}

class SlidersFetchInProgress extends SlidersState {}

class SlidersFetchSuccess extends SlidersState {
  final List<SliderDetails> sliders;

  SlidersFetchSuccess({required this.sliders});
}

class SlidersFetchFailure extends SlidersState {
  final String errorMessage;

  SlidersFetchFailure(this.errorMessage);
}

class SlidersCubit extends Cubit<SlidersState> {
  final SystemRepository systemRepository;

  SlidersCubit(
      {required this.systemRepository})
      : super(SlidersInitial());

  void fetchSliders() async {
    emit(SlidersFetchInProgress());
    try {
      final sliders = await systemRepository.fetchSliders();

      emit(SlidersFetchSuccess(sliders: sliders));
    } catch (e) {
      emit(SlidersFetchFailure(e.toString()));
    }
  }

  List<SliderDetails> getSliders() {
    if (state is SlidersFetchSuccess) {
      return (state as SlidersFetchSuccess).sliders;
    }
    return [];
  }
}
