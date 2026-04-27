import 'dart:async';

import 'package:get/get.dart';

import '../apis/index.dart';
import '../models/index.dart';

class TaskPollingService extends GetxService {
  TaskPollingService({required TaskApi taskApi}) : _taskApi = taskApi;

  final TaskApi _taskApi;
  final Map<String, Timer> _timers = {};

  void watch(
    GenerationTaskModel task, {
    required Future<void> Function(GenerationTaskModel task) onFinished,
    void Function(GenerationTaskModel task)? onTick,
    void Function(Object error)? onError,
  }) {
    cancel(task.taskId);
    if (task.status.isTerminal) {
      unawaited(onFinished(task));
      return;
    }

    _schedule(
      task.taskId,
      Duration(milliseconds: task.pollingIntervalMs),
      onFinished: onFinished,
      onTick: onTick,
      onError: onError,
    );
  }

  void cancel(String taskId) {
    _timers.remove(taskId)?.cancel();
  }

  void cancelAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }

  void _schedule(
    String taskId,
    Duration delay, {
    required Future<void> Function(GenerationTaskModel task) onFinished,
    void Function(GenerationTaskModel task)? onTick,
    void Function(Object error)? onError,
  }) {
    _timers[taskId] = Timer(delay, () async {
      try {
        final latest = await _taskApi.getTask(taskId);
        onTick?.call(latest);
        if (latest.status.isTerminal) {
          cancel(taskId);
          await onFinished(latest);
          return;
        }
        _schedule(
          taskId,
          Duration(milliseconds: latest.pollingIntervalMs),
          onFinished: onFinished,
          onTick: onTick,
          onError: onError,
        );
      } catch (error) {
        cancel(taskId);
        onError?.call(error);
      }
    });
  }

  @override
  void onClose() {
    cancelAll();
    super.onClose();
  }
}
