enum GenerationStatus { idle, queued, running, succeeded, failed }

GenerationStatus generationStatusFromJson(dynamic value) {
  final normalized = value?.toString().toLowerCase();
  switch (normalized) {
    case 'queued':
      return GenerationStatus.queued;
    case 'running':
      return GenerationStatus.running;
    case 'succeeded':
    case 'success':
    case 'completed':
      return GenerationStatus.succeeded;
    case 'failed':
    case 'cancelled':
    case 'canceled':
      return GenerationStatus.failed;
    case 'pending':
    case 'idle':
    default:
      return GenerationStatus.idle;
  }
}

extension GenerationStatusWire on GenerationStatus {
  String get wireName {
    switch (this) {
      case GenerationStatus.idle:
        return 'idle';
      case GenerationStatus.queued:
        return 'queued';
      case GenerationStatus.running:
        return 'running';
      case GenerationStatus.succeeded:
        return 'succeeded';
      case GenerationStatus.failed:
        return 'failed';
    }
  }

  bool get isActive {
    return this == GenerationStatus.queued || this == GenerationStatus.running;
  }

  bool get isTerminal {
    return this == GenerationStatus.succeeded ||
        this == GenerationStatus.failed;
  }
}
